# SaDaNiCode
Lenguaje de programación hecho en Pascal

# Estructura general
Un programa consiste de una secuencia de sentencias, comenzando por la declaración de las variables que se utilizarán en este programa, en donde se establecen los tipos de las mismas *(x := real)*. Estos tipos pueden ser números reales o arrays de números reales.
Luego se pasa al cuerpo del programa, el cual se ve limitado por las palabras reservadas **begin** y **end.**.

# Sentencias
Asignación: Para asignar un valor a una variable declarada se utiliza el operador **:=**, de manera tal que a la derecha del mismo esté el valor a guardar, y a la izquierda la variable en cuestión. Este valor puede ser una operación, como suma, resta, producto, división, potencia y raíz.
Lectura: Para almacenar un valor ingresado en pantalla, se utiliza la palabra reservada **read**, seguido por un paréntesis, en donde se escribe una constante de texto, y luego se agrega la variable en donde se va a almacenar este valor.
Escritura: En caso de querer escribir en pantalla, se hace a través de la palabra **write**, seguido de un paréntesis, en el cual se encuentra lo que se quiere mostrar, que puede ser una cadena de texto, un número, un array, o inclusive el resultado de algúna operación.
Condicional: Para realizar un condicional, se utiliza la palabra reservada **if**, seguido de la condición, y de **then**. A continuación, se pasa al cuerpo del condicional,  el cual se ve limitado por un **begin** y un **end;**. 
Ciclo **While**: Para definir un while, se ha de usar la palabra reservada **while**, seguido de la condición a cumplir, y de un **do**. Una vez hecho esto, se pasa al cuerpo del while, el cual se ve limitado por un **begin** y un **end;**.
Ciclo **For**: Para un for, se comienza con la palabra reservada **for** seguido de un corchete. El contenido del corchete se muestra a continuación:
*for [i := n to m]*
En donde tanto *n* como *m* pueden ser números reales y/o variables. Luego de esto, se pasa al cuerpo del for, el cual se ve limitado por un **begin** y un **end;**.

