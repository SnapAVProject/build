# bootstrap for the whole system
# 

unset LUNCH_MENU_CHOICES
function add_product_combo()
{
    local new_combo=$1
    local c
    for c in ${LUNCH_MENU_CHOICES[@]} ; do
        if [ "$new_combo" = "$c" ] ; then
            return
        fi
    done
    LUNCH_MENU_CHOICES=(${LUNCH_MENU_CHOICES[@]} $new_combo)
}

function plot_products_list()
{
    local allproducts

    allproducts=`find -L $1 -type f| cut -d '/' -f 3|cut -d '_' -f 1 |grep -v 'snapav'`
    for c in ${allproducts} ; do
        add_product_combo ${c}
    done

    local i=1
    local choice
    for choice in ${LUNCH_MENU_CHOICES[@]}
    do  
        echo "     $i. $choice"
        i=$(($i+1))
    done

    echo
}

function print_slogan()
{
    local ostype=`uname -rs`    

    echo "========= Hansong ========="
    echo "OS     : ${ostype}"
    echo "Product: ${BOARDTYPE}"
    echo "========= Hansong ========="
    sleep 2
}

function launch()
{
    local KERNEL_SRC="linux3.10/"
    local BUILDDEV_SRC="build/kernelconfig"

    local answer

    if [ "$1" ] ; then
        answer=$1
    else
        plot_products_list $BUILDDEV_SRC
        echo -n "Which product would you like?"
        read answer
    fi

    local selection=

    if (echo -n $answer |grep -q -e "^[0-9][0-9]*$")
    then
        if [ $answer -le ${#LUNCH_MENU_CHOICES[@]} ]
        then
            selection=${LUNCH_MENU_CHOICES[$(($answer-1))]}
        fi
    else
        selection=$answer
    fi

    if [ -e $BUILDDEV_SRC/${selection}_config ] ; then
        export BOARDTYPE=${selection}
        print_slogan
    else
        echo -e "\n\n******************\n"
        echo  -e "Your '${selection}' product is incorrect! \n"
        echo  -e "******************"
        unset BOARDTYPE
    fi    
}
