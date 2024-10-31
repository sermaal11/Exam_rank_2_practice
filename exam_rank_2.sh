#!/bin/bash

# Directorios de los niveles (cambia a la ruta correcta donde están los ejercicios)
levels=("/home/smarin-a/Scripts/exam_rank_2/Levels/level_1" "/home/smarin-a/Scripts/exam_rank_2/Levels/level_2" "/home/smarin-a/Scripts/exam_rank_2/Levels/level_3" "/home/smarin-a/Scripts/exam_rank_2/Levels/level_4")
current_level=0
vistos=()

# Función para mostrar un ejercicio aleatorio del nivel actual
mostrar_ejercicio() {
  clear
  nivel=${levels[$current_level]}
  ejercicios=("$nivel"/*)
  total_ejercicios=${#ejercicios[@]}
  if [ $total_ejercicios -eq 0 ]; then
    echo "No hay ejercicios en $nivel."
    return
  fi

  # Filtrar ejercicios ya vistos
  ejercicios_restantes=()
  for ejercicio in "${ejercicios[@]}"; do
    if [[ ! " ${vistos[@]} " =~ " $ejercicio " ]]; then
      ejercicios_restantes+=("$ejercicio")
    fi
  done

  if [ ${#ejercicios_restantes[@]} -eq 0 ]; then
    echo "Ya has visto todos los ejercicios de $nivel."
    return
  fi

  ejercicio_aleatorio=${ejercicios_restantes[$((RANDOM % ${#ejercicios_restantes[@]}))]}
  vistos+=("$ejercicio_aleatorio")
  echo -e "\nMostrando ejercicio aleatorio de $nivel:"
  cat "$ejercicio_aleatorio"
}

# Bucle principal
while true; do
  mostrar_ejercicio
  
  # Comprobar si quedan ejercicios restantes en el nivel actual
  nivel=${levels[$current_level]}
  ejercicios=("$nivel"/*)
  ejercicios_restantes=()
  for ejercicio in "${ejercicios[@]}"; do
    if [[ ! " ${vistos[@]} " =~ " $ejercicio " ]]; then
      ejercicios_restantes+=("$ejercicio")
    fi
  done

  if [ ${#ejercicios_restantes[@]} -eq 0 ]; then
    ((current_level++))
    if [ $current_level -ge ${#levels[@]} ]; then
      echo -e "\nHas terminado con todos los niveles. ¡Buen trabajo!"
      break
    fi
    echo -e "\nHas visto todos los ejercicios de $(basename ${levels[$current_level-1]}). Pasando al siguiente nivel: $(basename ${levels[$current_level]})"
    continue
  fi

  echo -e "\n\n¿Quieres ver otro ejercicio de $(basename ${levels[$current_level]})? (s/n) (o escribe 'q' para salir)"
  read respuesta
  if [[ "$respuesta" == "q" ]]; then
    echo -e "\nHas decidido salir. ¡Hasta luego!"
    clear
    break
  elif [[ "$respuesta" != "s" ]]; then
    ((current_level++))
    if [ $current_level -ge ${#levels[@]} ]; then
      echo -e "\nHas terminado con todos los niveles. ¡Buen trabajo!"
      break
    fi
    echo -e "\nPasando al siguiente nivel: $(basename ${levels[$current_level]})"
  fi
done