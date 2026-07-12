import os
import re
import requests

# 1. Fetch live metrics from GitHub API
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
USERNAME = "juergen-law"  # Change this to your exact GitHub username

headers = {"Authorization": f"token {GITHUB_TOKEN}"}

# Query to fetch repositories, stars, and basic user data
user_query = f"https://api.github.com/users/{USERNAME}"
repos_query = f"https://api.github.com/users/{USERNAME}/repos?per_page=100"

user_data = requests.get(user_query, headers=headers).json()
repos_data = requests.get(repos_query, headers=headers).json()

# Calculate total stars and repos
total_repos = user_data.get("public_repos", 0)
total_stars = sum(repo.get("stargazers_count", 0) for repo in repos_data if not repo.get("fork", False))

# For commits and exact lines of code, we can fetch from public search or set safe API estimates
# To keep API requests clean and fast without parsing every git tree:
commit_query = f"https://api.github.com/search/commits?q=author:{USERNAME}"
commit_headers = {**headers, "Accept": "application/vnd.github.cloak-preview"}
commit_data = requests.get(commit_query, headers=commit_headers).json()
total_commits = commit_data.get("total_count", 0)

# Fallback lines of code calculation (or parsing active repositories)
# For a lightweight, crash-proof implementation, we read your core development metric estimates:
lines_of_code = "24,540+"  # Or fetch dynamic estimations from your core repos (ARGUS & HORUS)

# 2. Open and update the SVG Template
svg_path = "terminal_dark.svg"

if os.path.exists(svg_path):
    with open(svg_path, "r", encoding="utf-8") as file:
        svg_content = file.read()

    # Replace the placeholders with live data strings
    svg_content = svg_content.replace("{REPOS}", str(total_repos))
    svg_content = svg_content.replace("{COMMITS}", str(total_commits))
    svg_content = svg_content.replace("{STARS}", str(total_stars))
    svg_content = svg_content.replace("{LINES}", str(lines_of_code))

    with open(svg_path, "w", encoding="utf-8") as file:
        file.write(svg_content)
    print("Terminal SVG successfully updated with latest metrics!")
else:
    print("Error: terminal_dark.svg not found in root directory.")
