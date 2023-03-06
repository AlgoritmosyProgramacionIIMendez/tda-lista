#!/bin/bash

count=`ls -1 src/*.c 2>/dev/null | wc -l`

if [ $count == 0 ] ; then
    cat ./badfile.txt
    echo ""
    echo "         No pude encontrar tus archivos."
    echo "  ¿Seguro que los pusiste en el directorio src?"
    echo ""
    echo "Asegurate de tener los archivos en el directorio correcto."
    echo ""
fi

if [ -f "tree.txt" ] ; then
    echo "Archivos Entregados"
    echo "==================="
    echo ""
    cat "tree.txt"
    echo ""
fi

if [ -f "banner.txt" ] ; then
    cat banner.txt
    echo ""
fi

echo "Linter"
echo "======"
echo ""

curl -ss "https://raw.githubusercontent.com/torvalds/linux/master/.clang-format" -o .clang-format
clang-format --style=file --Werror --dry-run $( find . \( -iname '*.h' -o -iname '*.c' \) )

if [ $? -ne 0 ]; then
    echo ""
    echo -e "\033[1;31m¡ERROR CORRIENDO CLANG:FORMAT! Revisa tu entrega, el estilo de código no fue respetado\033[0m"
    echo ""
    exit 1
fi

echo -e "\033[1;32mLINTER OK\033[0m"
echo ""

echo "Compilación y pruebas"
echo "====================="
echo ""

make -f makefile-chanutron clean    2>&1
sudo timeout 30s make -f makefile-chanutron valgrind 2>&1

RETVAL=$?
#Ojo con esto. Pa2mmf devuelve 0 para éxito, 2 para error, Pa2mm devuelve 0 para éxito y >0 para error. Si fallan justo 124 pruebas, va a salir como timeout. Creo.
if [ $RETVAL -eq 2 ]; then
    echo ""
    echo -e "\033[1;31m¡ERROR CORRIENDO VALGRIND! Revisa tu entrega\033[0m"
    echo ""
    exit 1
fi

if [ $RETVAL -eq 124 ]; then
    echo ""
    echo -e "\033[1;31m¡TIMEOUT! Revisa tu entrega\033[0m"
    echo ""
    exit 2;
fi

echo ""
echo "Parece que tu TP pasa todas las pruebas."
echo ""
cat success.txt

exit 0
