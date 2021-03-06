######################################################################
# Script to list all unused git branches according to specified time #
######################################################################

# The method in used is to first iterate on the brnches sorted by last commit date
# and then for each branch we will check for the last commit(change)
# the ones with no changes in the last month will be printed
# excluding the branches with release in their branch name

# git log --since="1 month ago"  branchName
# Show the changes during the last month to the branch named branchName.
# returns an empty log if no commits were added
# grep -v <string> --> -v flag will exclude all the strings with the <string> you want

# --format= %cr-takes the date of  the commit in the branch
#           %an-takes the name of the authour of the commit in the brance
# LastCommit => an env variable sent from the pipeline to set the date we want to check
# DryRun => an env variable sent from the pipeline to set if deletion will take place or not

# Regular Colors just for better understanding of output
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White
NC='\033[0m'        # No Color
########################################################



for branch in $(git branch -r --sort=-committerdate | grep -v release); do
        
        
        if ! [ "$(git log --since="{$LastCommit}" $branch)" ]; then 
                echo "$(git show --format="Last activity was ${Red}%cr${NC} By: ${Blue}%an${NC}" $branch | head -n 1) Branch name: ${Blue}$branch${NC}"
                if [ ${DryRun} = 'True' ]; then
                        git branch -d $branch
                        git push origin -d $branch
                        echo "Brnach deleted"
                fi        
        fi

done
