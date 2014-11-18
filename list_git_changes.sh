#/bin/sh

# A script to list the changed files in all git repos at top level of a particular directory.

while getopts ":d:i:" opt; do
  case $opt in
    d) directory_to_search="$OPTARG"
    ;;
    i) repo_to_ignore="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if ! [ $directory_to_search ]
then
    echo "Sorry, -d must be used to specify a directory containing your repos to scan (example: \"list_git_changes.sh -d ~/Documents\")" >&2
    exit 1
fi

repo_counter=0 # Number of found repos.

echo "";

for d in "$directory_to_search"/* # For every directory in Documents,
do
   if [[ -d "$d/.git" ]]; then # If it has a .git directory inside
   
    cd $d; # Change to the directory
    
    if ! ( output=$(git status --porcelain) && [ -z "$output" ] ); # If git status says there are changes,
    then
  
  		if ! ( [ $repo_to_ignore ] && [[ $d = *$repo_to_ignore* ]] ) # If this isn't a repo which we are ignoring or we aren't ignoring a repo,

		then
			reponame=`basename $d`; # Get the name at the end of the path – this is the repo name.
			repetitions=${#reponame};
			num=$(($repetitions + 6))
			head -c $num < /dev/zero | tr '\0' '\45'; # So pretty.
			echo "";
			echo %% $reponame %%; # Show the name.
			head -c $num < /dev/zero | tr '\0' '\45';
			echo "";			
    		(git status --short); # Output its git status in short form.
    		echo "";
    		repo_counter=$[$repo_counter +1]; # Increment numbers of found repos.
		fi
	fi
fi

done

if [ "$repo_counter" -eq 0 ]; then # No repos found with changes.
	echo "";
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	echo "%%                                         %%";	
	echo "%% No repositories have any changed files. %%";
	echo "%%                                         %%";	
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	echo "";
fi

 