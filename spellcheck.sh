# Kru Shah
# Spell checks words in a text file, prompts user to fix or ignore misspelled words, and updates changes as indicated.

count=0
bold=`tput bold`
normal=`tput sgr0`

replaceWord()
{
  echo "" 
  echo "Misspelled word: ${bold}$word${normal}"  
  grep -n $word $filename # display all instances of the word in the context of the text file
  read -p "Press "Enter" to ignore, "q" to quit, or type replacement here: " correction
  if [ "$correction" = "q" ] || [ "$correction" = "quit" ] # quits, but saves changes that were already made
  then  
    echo ""
    echo "Exiting... CHANGED $count WORD(S)."; 
    exit 0
  elif [ "$correction" = "" ]
  then
    echo "Ignored misspelled word $word..."
  else 
    sed -i "s/$word/$correction/g" $filename # replace word in file at all instances
    let count=$((count+1)) # increment number of changes made
  fi   
}


if ! which hunspell >/dev/null; then # if hunspell is not already installed, install it
  echo "First, we need to install hunspell..."
  sudo apt-get install hunspell # prompt user to install hunspell
fi


echo ""
echo -n "Enter name of file that you want spell checked: "
read filename
if [ ! -r $filename ] # if file is not readable, exit
then 
  echo "ERROR: Cannot read file $filename"; echo ""; exit 1
fi

# create an array of misspelled words, using the output from "hunspell -l"
array=($(hunspell -l < $filename | sed 's/:.*//' | sort -u)) # sort by unique misspelled words, no repeats, but includes capitals
if [ ${#array[@]} == 0 ] # if the length of the misspelled array is 0, there are no spelling errors
then 
  echo "$filename has no spelling errors!"
  echo ""
  exit 0
else # if array is not empty
  cp "$filename" "$filename.bak" # create backup of original file, with .bak extension 
  for word in ${array[@]}; # loop through all misspelled words in array
  do
    replaceWord $word $filename # function that prompts user to make changes
  done
fi

echo ""
echo "CHANGED $count WORD(S)."
exit 0
