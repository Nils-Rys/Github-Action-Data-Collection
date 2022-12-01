### Data Collection from GitHub

Author(s): Nils Rys-Recker, Kai Arakawa Hicks

# Install and Use Virtualen

Install virtualen on your machine first: https://gist.github.com/Geoyi/d9fab4f609e9f75941946be45000632b

Use virtualen for a clean environment of ONLY Python3.

Go to the working directory, then type:
```
virtualenv -p /usr/bin/python3 folder_name

```
Activate virtualen:
```
source folder_name/bin/activate
```

After that, you will see that each line on your terminal starts with (folder_name).

When you are done working, you can deactivate the virtualenv by typing:
```
deactivate
```

Note 1: Replace folder_name with an actual folder name.

Note 2: Add the name of your virtualen folder to .gitignore file.

# Use github3.py

Move to your working directory, and activate virtualen first. After that, install github3.py in the virtual environment by typing:

```
pip install github3.py
```

# Data collection
Create a GitHub Personal access token with repo scope.

Type:
```
python3 datacollection.py (Organization Name) (Git Token) (assingment name)
```

(Organization Name) is the name for the github organization.
(Git Token) is the personal access token with repo scope
(assingment name) is the name for the assignment, for example Lab-1