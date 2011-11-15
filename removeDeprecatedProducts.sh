#!/bin/bash
# To use this script, simple type ./removeDeprecatedProducts BRANCH_NAME to remove
# all deprecated products from the specified branch.

# Place this script in the same folder as repoutil, otherwise it will not work properly.

while getopts b:i: opt; do
        case "$opt" in
		b) branch="$OPTARG";;
                i) items="$OPTARG";;
		h) 
			help
			exit 0;;
		\?)
			help
			exit 0;;
	esac
done
shift `expr $OPTIND - 1`

# Sanity Check.  Makes sure a branch is specified.
#if [ -z $1 ]
#then
#        echo "Please specify a branch"
#        exit 1
#fi

# Set items to only remove Deprecated if nothing is specified
if [ -z $items ]; then
        items = "Deprecated"
fi

# Iterates through the output that shows deprecated items in a given branch.
i=0
for item in $(./repoutil --list-branch="$branch" | grep "$items" | cut -f1 -d ' ')
do
        deprecatedProducts[$i]=$item
        let i++
done

# Removes deprecated products
for product in "${deprecatedProducts[@]}"
do
        ./repoutil --remove-product=$product $1
        echo "Removed ${product}"
done
