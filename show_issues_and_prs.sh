#!/usr/bin/env bash

# List of file names for saving outputs from Github CLI. This makes sure
# we don't hit Github more then necessary.
issues_assigned_to_me="assigned-to-me.json"
pr_reviewed_by_me="reviewed-by-me-prs.json"
prs_review_requested="review-requested-prs.json"

# For the below Github CLI commands, I only grab url because the goal of this script
# is to open up the issues in the browser only
if [[ ! -f $issues_assigned_to_me ]]; then
    gh issue list --assignee "@me" --json url >>$issues_assigned_to_me
fi

if [[ ! -f $pr_reviewed_by_me ]]; then
    gh pr list --search "reviewed-by:@me" --json url >>$pr_reviewed_by_me
fi

if [[ ! -f $prs_review_requested ]]; then
    gh pr list --search "review-requested:@me" --json url >>$prs_review_requested
fi

what_to_open=("$prs_review_requested" "$pr_reviewed_by_me" "$issues_assigned_to_me")

for file in "${what_to_open[@]}"; do
    echo "$file"
    values=($(jq '.[].url' $file))
    for url in "${values[@]}"; do
        open -u $(eval echo $url)
    done

    open -u https://www.google.com
    sleep 5
done
