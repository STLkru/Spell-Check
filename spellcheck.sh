# Kru Shah
# Spell checks words in text file and prompts user to retype misspelled words, or ignore the mispelled words altogether. 

# In order to run the script, "ispell" needs to be installed
# install ispell: sudo apt-get install ispell/hunspell



checkSpelling()
{
  echo "IN FUNCTION"
  echo ""; echo "${boldon}Misspelled word ${word}:${boldoff}"
  #grep -n $word $filename | sed -e 's/^/   /' -e "s/$word/$boldon$word$boldoff/g" # this line obtains line number and displays whole line of missing word
  echo -n "i)gnore, q)uit, or type replacement: "
  read fix
  
  if [ "$fix" = "q" -o "$fix" = "quit" ] ; then
    echo "Exiting without applying any fixes."; exit 0
  elif [ "$fix" = "i" -o -z "$fix" ] ; then
    echo "Ignored misspelled word $word."    
  else echo "s/$word/$fix/g" >> $changerequests
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
errors="$($spell < $filename | tee $tempfile | wc -l | sed 's/[^[:digit:]]//g')" #outputs spelling errors in tempfile
if [ $errors -eq 0 ] #if there are no spelling errors, let the user know
then 
  echo "There are no spelling errors in $filename."
  exit 0
else
  for word in $(cat $tempfile) #go through all misspelled words in tempfile
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
