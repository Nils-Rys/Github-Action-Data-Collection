import csv
from urllib import parse

import github3
import requests
import sys

#from . import parse_log as _parse
import parse_log as _parse


def fetch_data(organization_name, github_token, assignment_name,
	filepath_repo = None, filepath_commit = None, debug = False):
	"""
	Generates a CSV file where each row stands for a repository in the specified organization
	The first column is the URL to the repository homepage and the second column has the number of commits made to the repository

	Parameters
	----------
	organization_name : str
		The organization to read repositories from
	github_token : str
		A github token with at least the following permissions
		 - Repo
	assignment_name : str
		a string containing the name of the assignment
	filepath_repo : str
		The filepath to save the CSV file with information on repositories
		If None, the repository information will be returned
	filepath_commit : str
		The filepath to save the CSV file with information on commits
		If None, the commit information will be returned
	debug = False : bool
		If true, extra information will be printed for debugging purposes
		For standard use, leave false

	Returns
	-------
	Assuming one of the paths is left None, the information that would be written to the CSV is returned.
	It will take this form:
		[
			{'prop1': 'val1', 'prop2': 'val2', ...},
			{'prop1': 'val1', 'prop2': 'val2', ...},
			...
		]
	"""

	#create a github session object with the github3.py library
	github_session = github3.login(token = github_token)
	#create an organization object to access all repositories in an organization
	organization = github_session.organization(organization_name)

	#open the files for writing
	#one for the commits
	if filepath_commit is not None:
		file_commit = open(filepath_commit, 'w')
		writer_commit = csv.writer(
			file_commit,
			dialect = "excel"
		)
	else:
		commits_out = []
	if filepath_repo is not None:
		file_repo = open(filepath_repo, 'w')
		writer_repo = csv.writer(
			file_repo,
			dialect = "excel"
		)
	else:
		repos_out = []

	#prepare the headers
	header_repo = [
		"repo_name", "commits_count"
	]
	header_commit = [ #repo index is meant for constant time lookup also it starts at 2 because after
						#the header, excel will display the first row as 2
		"username", "commit_number", "timestamp", "repo", "tests_count", "tests_failed", "build_error", "added", "deleted"
	]

	#write the headers
	if filepath_repo is not None:
		writer_repo.writerow(header_repo)
	if filepath_commit is not None:
		writer_commit.writerow(header_commit)

	#the rows to be written to the commits table will be stored here
	commits = []

	#starting the index at 2 because excel sucks
	repo_index = 2
	# will keep track of the amount of commits
	num_commits = 0
	#iterating through all repositories in an organization
	for repo in list(organization.repositories(type = "all")):
		repo_name = str(repo)
		print(repo)
		# repo = ""
		
		if assignment_name in repo_name:
			#get the states (pass/fail/canceled) of every build associated with the current repo
				#building the headers for the API call
			headers = {
				"Authorization": "token {}".format(github_token)
			}

			#grabs all the runs data from the repo
			response = requests.get(
				url = "https://api.github.com/repos/{0}/actions/runs".format(
					str(repo),
					"temp1"
				),
				headers = headers
			)
			data = response.json()
			# remove all non branch specific runs
			specialBranch = "reWorkflow"
			tempJson = []
			for tempData in data['workflow_runs']:
				
				if(tempData['head_branch'] != specialBranch):
					tempJson.append(tempData)
					
			for tempData in tempJson:
				# print("removed 1")
				data['workflow_runs'].remove(tempData)

			# print(data)
			# print("\n\n BREAK \n\n")
			# grabs all the commit data from the repo
			git_commit = requests.get(
				url = "https://api.github.com/repos/{0}/commits?page=1&sha={1}".format(
					str(repo),
					specialBranch

				),
				headers = headers
			).json()
			# print(git_commit)
			commits_count = len(git_commit)
			page = 1
			commit_number = 0
			rebase_commit = 0
			rebase_page = 1
			prev_workflow = ""
			for workflow_iterator in data["workflow_runs"]:
				rebase_commit = commit_number
				rebase_page = page
				# In case the workflow has duplicates somehow
				if(prev_workflow != workflow_iterator["head_sha"]):
					name = workflow_iterator["actor"]["login"]
					timestamp = workflow_iterator["updated_at"]
					# gets all commits between actions
					# print(workflow_iterator["head_sha"])
					# print(git_commit[commit_number]["sha"])

					while(commit_number < commits_count and workflow_iterator["head_sha"] != git_commit[commit_number]["sha"]):

						commit_request = requests.get(
							url = "https://api.github.com/repos/{0}/commits/{1}?sha={2}".format(
								str(repo),
								git_commit[commit_number]["sha"],
								specialBranch
							),
							headers = headers
						).json()
						print(commit_request["stats"])
						# print("\n\nBREAK \n\n")
						additions = commit_request["stats"]["additions"]
						deletions = commit_request["stats"]["deletions"]

						if(commit_request["author"] is None):
							name = "N/A"
						else:
							name = commit_request["author"]["login"]
						commits.append([
							name,
							(commits_count - commit_number -1),
							commit_request["commit"]["committer"]["date"],
							str(repo),
							0,
							0,
							"False",
							additions,
							deletions
						])
						num_commits += 1
						commit_number += 1
						# Checks if reached the end of the git page
						if(commit_number == 30):
							page += 1
							git_commit = requests.get(
								url = "https://api.github.com/repos/{0}/commits?page={1}&sha={2}".format(
									str(repo),
									page,
									specialBranch
								),
								headers = headers
							).json()
							commits_count = len(git_commit)
							commit_number = 0
						
					# Checks if reached the end of the git page
					if(commit_number == 30):
						page += 1
						git_commit = requests.get(
							url = "https://api.github.com/repos/{0}/commits?page={1}&sha={2}".format(
								str(repo),
								page,
								specialBranch
							),
							headers = headers
						).json()
						commits_count = len(git_commit)
						commit_number = 0
					# print("AFTER Workflow: "+workflow_iterator["head_sha"])
					# if(commit_number<commits_count):
					# 	print("AFTER git commit: "+git_commit[commit_number]["sha"])
					# else:
					# 	print("NO after Git")
					# print(commits_count)
					# print(commit_number)
					
					if(commit_number<commits_count):
						# grabs the changed line count from the workflows commit
						changed_lines = requests.get(
							url = "https://api.github.com/repos/{0}/commits/{1}?sha={2}".format(
								str(repo),
								git_commit[commit_number]["sha"],
								specialBranch
							),
							headers = headers
						).json()["stats"]#["total"]
						additions = changed_lines["additions"]
						deletions = changed_lines["deletions"]
						# print(changed_lines)
						commit_number += 1

						# Gets all workflow jobs
						workflow_response = requests.get(
							url = "{0}".format(
								workflow_iterator["jobs_url"]
							),
							headers = headers
						)
						# print(workflow_response.json())
						job_id = workflow_response.json()["jobs"][0]["id"]

						# grabs the build log from the workflow	 
						build_log = requests.get(
							url = "https://api.github.com/repos/{0}/actions/jobs/{1}/logs".format(
								str(repo),
								job_id
							),
							headers = headers
						).text
						# parses build log to see if the build was a success
						info = _parse.get_pass_rate(build_log)
						# case where build error occured
						if(len(info) == 0):
							tests_count = 1
							tests_failed = 1
							build_error = "True"
						# case where passed all test cases
						elif(len(info) == 1):
							tests_count = 1
							tests_failed = 0
							build_error = "False"
						# case where failed some test cases
						elif(len(info) == 2):
							tests_count = info[0]
							tests_failed = info[1]
							build_error = "False"
						# case to catch failures, outside of what was found
						else:
							tests_count = info[0]
							tests_failed = info[0]
							build_error = "True"
						
						# appends the commit info to othe commit array which will transfer info to the csv
						commits.append([
							name,
							(commits_count - commit_number -1),
							timestamp,
							str(repo),
							tests_count,
							tests_failed,
							build_error,
							additions,
							deletions

							
						])
						prev_workflow = workflow_iterator["head_sha"]
					# end reached checks for rebase scenario
					else:
						while(commit_number != rebase_commit or page != rebase_page ):
							# print("removing a commit")
							if(commit_number == 0):
								rebase_page -= 1
								commit_number = 29
								git_commit = requests.get(
									url = "https://api.github.com/repos/{0}/commits?page={1}&sha={2}".format(
										str(repo),
										page,
										specialBranch
									),
									headers = headers
								).json()
								commits_count = len(git_commit)

							else:
								commit_number -= 1
							num_commits -= 1
							commits.pop()





			num_commits += 1
			# Retreives all commits done before the action tests
			while(commit_number < commits_count):
				commit_request = requests.get(
					url = "https://api.github.com/repos/{0}/commits/{1}?sha={2}".format(
						str(repo),
						git_commit[commit_number]["sha"],
						specialBranch
					),
					headers = headers
				).json()
				
				additions = commit_request["stats"]["additions"]
				deletions = commit_request["stats"]["deletions"]

				if(commit_request["author"] is None):
					name = "N/A"
				else:
					name = commit_request["author"]["login"]

				timestamp = commit_request["commit"]["committer"]["date"]
				commit_number += 1

				commits.append([
					name,
					(commits_count - commit_number -1),
					timestamp,
					str(repo),
					0,
					0,
					"False",
					additions,
					deletions
				])
				num_commits += 1
				if(commit_number == 30):
					page += 1
					git_commit = requests.get(
						url = "https://api.github.com/repos/{0}/commits?page={1}&sha={2}".format(
							str(repo),
							page,
							specialBranch
						),
						headers = headers
					).json()
					commits_count = len(git_commit)
					commit_number = 0



	print("reached end")
	#write all the rows to the commit table
	for commit_row in commits:
		if filepath_commit is not None:
			writer_commit.writerow(commit_row)
		else:
			commit_dict = {}
			for i in range(len(commit_row)):
				commit_dict[header_commit[i]] = commit_row[i]
			commits_out.append(commit_dict)

	if filepath_commit is not None:
		file_commit.close()
	if filepath_commit is None:
		return commits_out



if __name__ == '__main__':
	org_name = sys.argv[1]
	github_token = sys.argv[2]
	assignment_name = sys.argv[3]
	fetch_data(
		org_name,
		filepath_repo = "./repositories.csv",
		filepath_commit = "./commits.csv",
		github_token = github_token,
		assignment_name = assignment_name,
		debug = True
	)
