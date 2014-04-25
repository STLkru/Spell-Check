# Kru Shah
# Spell checks words in text file and prompts user to retype misspelled words, or ignore the mispelled words altogether. 

# In order to run the script, "ispell" needs to be installed
# install ispell: sudo apt-get install ispell/hunspell

changerequests="/tmp/$0.$$.sed"

checkSpelling()
{
  echo "Misspelled word $word"  
  read -p "$word is mispelled. Press "Enter" to ignore, "q" to quit, or type replacement here: " correction
  
  if [[ "$correction" = "q" ]] ; then
    echo "Exiting without applying any fixes."; 
    exit 0
  elif [[ "$correction" = "" ]] ; then
    echo "Ignored misspelled word $word."
  else echo "s/$word/$correction/g" >> $changerequests
  fi 
}


echo -n "Enter name of file that you want spell checked: "
read filename

# If file is not readable, return error
if [ ! -r $filename ] 
then 
  echo "ERROR: Cannot read file $filename"; exit 1
fi

touch $changerequests #create new temp file?



array=($(hunspell -l < $filename | sed 's/:.*//')) #create an array of misspelled words
if [ ${#array[@]} == 0 ] #if the length of the misspelled array is 0, exit
then 
  echo "$filename has no errors!"
  exit 0
else #if array is not empty
  echo ""
  for word in ${array[@]}; #go through all misspelled words in array
  do
    checkSpelling $word $filename
  done
fi



if [ $(wc -l < $changerequests) -gt 0 ] ; then
  sed -f $changerequests $filename > $filename.new
  mv $filename $filename.shp
  mv $filename.new $filename
  echo Done. Made $(wc -l < $changerequests) changes.
fi

exit 0
