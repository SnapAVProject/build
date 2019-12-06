


function launch()
{
    local KERNEL_SRC="linux3.10/"
    # launch ...
    if [ $# -eq 0 ] ; then
        echo 'launch snapxx [appversion dspversion]'
        return
    fi
    local boardtype
    if [ "$1" ] ; then
        boardtype=$1
    else
        echo -n "Which would you like? [snapav51] "
        read boardtype
    fi

    echo "Now the boardtype:${boardtype}"
    export BOARDTYPE=${boardtype}
    cp build/kernelconfig/${BOARDTYPE}_config ${KERNEL_SRC}/.config
}