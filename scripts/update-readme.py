import os
import re
import json
import subprocess
from datetime import datetime
from collections import defaultdict
import requests

# Constants
TOTAL_LEETCODE_PROBLEMS = 3000
IGNORE_DIRS = {'.git', '.github', 'scripts', 'node_modules'}
EXT_MAP = {
    '.sql': 'SQL',
    '.cpp': 'C++',
    '.java': 'Java',
    '.py': 'Python',
    '.js': 'JavaScript',
    '.ts': 'TypeScript',
    '.c': 'C',
    '.cs': 'C#',
    '.go': 'Go',
    '.rb': 'Ruby',
    '.swift': 'Swift',
    '.rs': 'Rust',
    '.php': 'PHP'
}

def get_git_history():
    """Fetches git log to calculate streaks and dates."""
    try:
        result = subprocess.run(
            ['git', 'log', '--name-status', '--format=%H|%aI|%s'], 
            capture_output=True, text=True, check=True
        )
        return result.stdout.strip().split('\n')
    except subprocess.CalledProcessError:
        return []

def get_problem_metadata(slug):
    """Fetches problem difficulty from LeetCode GraphQL API."""
    url = "https://leetcode.com/graphql"
    query = """
    query questionTitle($titleSlug: String!) {
      question(titleSlug: $titleSlug) {
        difficulty
      }
    }
    """
    try:
        response = requests.post(url, json={'query': query, 'variables': {'titleSlug': slug}}, timeout=5)
        data = response.json()
        return data['data']['question']['difficulty']
    except:
        return "Unknown"

def generate_progress_bar(current, total, length=30):
    filled = int(length * current // total)
    return '█' * filled + '░' * (length - filled)

def parse_directories():
    problems = []
    languages = defaultdict(int)
    total_sql = 0
    total_algo = 0
    
    for item in os.listdir('.'):
        if os.path.isdir(item) and item not in IGNORE_DIRS and re.match(r'^\d+-', item):
            slug = item.split('-', 1)[1]
            files = os.listdir(item)
            
            problem_langs = []
            is_sql = False
            for f in files:
                _, ext = os.path.splitext(f)
                if ext in EXT_MAP:
                    lang = EXT_MAP[ext]
                    problem_langs.append(lang)
                    languages[lang] += 1
                    if lang == 'SQL':
                        is_sql = True
            
            if is_sql:
                total_sql += 1
            elif problem_langs:
                total_algo += 1
                
            if problem_langs:
                problems.append({
                    'folder': item,
                    'slug': slug,
                    'langs': problem_langs,
                    'is_sql': is_sql
                })
                
    return problems, languages, total_sql, total_algo

def calculate_streaks(git_lines):
    dates = set()
    for line in git_lines:
        if '|' in line:
            parts = line.split('|')
            if len(parts) >= 2:
                date_str = parts[1][:10] # YYYY-MM-DD
                dates.add(datetime.strptime(date_str, '%Y-%m-%d').date())
    
    if not dates:
        return 0, 0, 0
        
    sorted_dates = sorted(list(dates))
    repo_age = (datetime.now().date() - sorted_dates[0]).days + 1
    
    current_streak = 0
    longest_streak = 0
    temp_streak = 1
    
    for i in range(1, len(sorted_dates)):
        if (sorted_dates[i] - sorted_dates[i-1]).days == 1:
            temp_streak += 1
        else:
            if temp_streak > longest_streak:
                longest_streak = temp_streak
            temp_streak = 1
            
    if temp_streak > longest_streak:
        longest_streak = temp_streak
        
    # Check current streak
    if sorted_dates and (datetime.now().date() - sorted_dates[-1]).days <= 1:
        current_streak = temp_streak
        
    return current_streak, longest_streak, repo_age

def update_readme(content, placeholders):
    for key, value in placeholders.items():
        pattern = f"(<!--{key}_START-->).*(<!--{key}_END-->)"
        content = re.sub(pattern, rf"\g<1>{value}\g<2>", content, flags=re.DOTALL)
    return content

def main():
    print("Parsing directories...")
    problems, languages, total_sql, total_algo = parse_directories()
    total_solved = len(problems)
    
    print("Fetching difficulties from LeetCode...")
    difficulties = {'Easy': 0, 'Medium': 0, 'Hard': 0, 'Unknown': 0}
    for prob in problems:
        diff = get_problem_metadata(prob['slug'])
        prob['difficulty'] = diff
        difficulties[diff] = difficulties.get(diff, 0) + 1
        
    print("Analyzing Git history...")
    git_lines = get_git_history()
    commits = [line for line in git_lines if '|' in line]
    current_streak, longest_streak, repo_age = calculate_streaks(git_lines)
    
    # Calculate Languages HTML
    lang_html = ""
    for lang, count in sorted(languages.items(), key=lambda x: x[1], reverse=True):
        pct = (count / total_solved) * 100 if total_solved > 0 else 0
        lang_html += f"  <tr>\n    <td>{lang}</td>\n    <td>{count}</td>\n    <td>{pct:.1f}%</td>\n  </tr>\n"
        
    # Recent Activity
    activity_html = ""
    processed = set()
    count = 0
    for line in commits:
        if count >= 10: break
        parts = line.split('|')
        if len(parts) >= 3:
            msg = parts[2]
            if msg not in processed and ("Add" in msg or "Sync" in msg):
                date_str = parts[1][:10]
                activity_html += f"**{date_str}**<br/>✔ {msg}<br/>\n\n"
                processed.add(msg)
                count += 1
                
    if not activity_html: activity_html = "*No recent activity detected.*"
    
    # Timeline
    timeline_counts = defaultdict(int)
    for line in commits:
        if '|' in line:
            parts = line.split('|')
            if len(parts) >= 2:
                ym = parts[1][:7] # YYYY-MM
                timeline_counts[ym] += 1
                
    timeline_html = ""
    for ym in sorted(timeline_counts.keys(), reverse=True)[:6]:
        dt = datetime.strptime(ym, '%Y-%m')
        month_name = dt.strftime('%B %Y')
        bars = '█' * min(timeline_counts[ym], 30)
        timeline_html += f"**{month_name}** {bars} ({timeline_counts[ym]})\n\n"
        
    # Latest Problem
    latest_problem = "Pending"
    latest_diff = "-"
    latest_lang = "-"
    latest_date = "-"
    latest_hash = "-"
    latest_msg = "-"
    if commits:
        latest = commits[0].split('|')
        latest_hash = latest[0][:7]
        latest_date = latest[1].replace('T', ' ')[:19]
        latest_msg = latest[2]
        if problems:
            latest_problem = problems[-1]['folder']
            latest_diff = problems[-1]['difficulty']
            latest_lang = ", ".join(problems[-1]['langs'])

    # Build placeholders
    placeholders = {
        'TOTAL_SOLVED': total_solved,
        'PROGRESS_BAR': generate_progress_bar(total_solved, TOTAL_LEETCODE_PROBLEMS),
        'PERCENTAGE': f"{(total_solved / TOTAL_LEETCODE_PROBLEMS) * 100:.2f}%",
        'CURRENT_STREAK': f"{current_streak} days",
        'LONGEST_STREAK': f"{longest_streak} days",
        'TOTAL_PROBLEMS': total_solved,
        'TOTAL_PROGRAMMING': total_algo,
        'TOTAL_SQL': total_sql,
        'TOTAL_EASY': difficulties['Easy'],
        'TOTAL_MEDIUM': difficulties['Medium'],
        'TOTAL_HARD': difficulties['Hard'],
        'LANGUAGES': lang_html.strip(),
        'LATEST_PROBLEM': latest_problem,
        'LATEST_DIFFICULTY': latest_diff,
        'LATEST_LANGUAGE': latest_lang,
        'LATEST_DATE': latest_date,
        'LATEST_HASH': latest_hash,
        'LATEST_MESSAGE': latest_msg,
        'RECENT_ACTIVITY': activity_html.strip(),
        'TIMELINE': timeline_html.strip(),
        'REPO_AGE': f"{repo_age} days",
        'TOTAL_COMMITS': len(commits),
        'AVG_PER_WEEK': f"{total_solved / (repo_age / 7):.1f}" if repo_age > 0 else "0",
        'LAST_UPDATED': datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')
    }

    # Update README
    print("Updating README.md...")
    with open('README.md', 'r', encoding='utf-8') as f:
        content = f.read()
        
    new_content = update_readme(content, placeholders)
    
    with open('README.md', 'w', encoding='utf-8') as f:
        f.write(new_content)
        
    print("Done!")

if __name__ == "__main__":
    main()
