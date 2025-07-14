# This module contains hooks for adding things to my diary.

create_diary_note() {
  local DAY=$(date +%F)
  local file=~/workspace/wiki/wiki/Diary/${DAY}.md

  cat > "$file" <<EOF
---
day: ${DAY}
location: 
---
[[Diary]] entry for ${DAY}
## Completed Today
\`\`\`dataview
TABLE WITHOUT ID
  file.link AS Task,
  type AS Type, 
  created AS Created, 
  deprecated AS dep
FROM "TASKS"
WHERE 
  completed = date(${DAY})
SORT created ASC
\`\`\`
# Notes

EOF
}


add_diary_entry() {
  local text="$1"
  local file=~/workspace/wiki/wiki/Diary/$(date +%F).md
  local timestamp=$(date +%H%M)

  if [[ ! -f "$file" ]]; then
    echo "Diary file not found, creating it..."
    create_diary_note || { echo "Failed to create diary note." >&2; return 1; }
  fi
  
  # Ensure there's an empty line at the end
  [[ $(tail -c1 "$file" | wc -l) -eq 0 ]] && echo "" >> "$file"

  echo "- $timestamp $text" >> "$file"
}
