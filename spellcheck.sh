# Kru Shah
# Spell checks words in a text file, prompts user to fix or ignore misspelled words, and updates changes as indicated.

count=0

replaceWord()
{
  echo ""
  echo "Misspelled word: $word"  
  grep -n $word $filename # display words in the line context
  read -p "Press "Enter" to ignore, "q" to quit, or type replacement here: " correction
  if [[ "$correction" = "q" ]] ; then
    echo "Exiting... MADE $count WORD CHANGE(S)."; 
    echo ""
    exit 0
  elif [[ "$correction" = "" ]] ; then
    echo "Ignored misspelled word $word..."
  else 
    sed -i "s/$word/$correction/g" $filename #replace word in file at all instances
    let count=$((count+1))
  fi   
}


if ! which hunspell >/dev/null; then # if hunspell is not already installed, install it
  echo "First, we need to install hunspell..."
  sudo apt-get install hunspell # prompt user to install hunspell
fi


echo ""
echo -n "Enter name of file that you want spell checked: "
read filename
if [ ! -r $filename ] # If file is not readable, exit
then 
  echo "ERROR: Cannot read file $filename"; echo ""; exit 1
fi

#create an array of misspelled words, using the output from "hunspell -l"
array=($(hunspell -l < $filename | sed 's/:.*//' | sort -u)) #add only unique misspelled words, no repeats
if [ ${#array[@]} == 0 ] #if the length of the misspelled array is 0, exit
then 
  echo "$filename has no spelling errors!"
  echo ""
  exit 0
else #if array is not empty
  cp "$filename" "$filename.bak" # create backup of original file, with .bak extension 
  for word in ${array[@]}; #go through all misspelled words in array
  do
    replaceWord $word $filename
  done
fi

echo ""
echo "MADE $count WORD CHANGE(S)."
exit 0
