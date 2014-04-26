# Kru Shah
# Spell checks words in text file, prompts user to fix or ignore misspelled words, and updates changes as indicated



replaceWord()
{
  echo ""
  echo "Misspelled word $word"  
  read -p "$word is mispelled. Press "Enter" to ignore, "q" to quit, or type replacement here: " correction
  if [[ "$correction" = "q" ]] ; then
    echo "Exiting..."; 
    exit 0
  elif [[ "$correction" = "" ]] ; then
    echo "Ignored misspelled word $word."
  else sed -i -e "s/$word/$correction/g" $filename #fix word in file
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
  echo "ERROR: Cannot read file $filename"; exit 1
fi



array=($(hunspell -l < $filename | sed 's/:.*//')) #create an array of misspelled words, using the output from "hunspell -l"
if [ ${#array[@]} == 0 ] #if the length of the misspelled array is 0, exit
then 
  echo "$filename has no spelling errors!"
  exit 0
else #if array is not empty
  echo ""
  for word in ${array[@]}; #go through all misspelled words in array
  do
    replaceWord $word $filename
  done
fi

exit 0
