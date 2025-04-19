#!/bin/bash

# Répertoire contenant les données originales
DATASET_DIR="ships32"
OUTPUT_DIR="ships_split"
TRAIN_DIR="$OUTPUT_DIR/train"
VAL_DIR="$OUTPUT_DIR/val"

# Ratio validation (20% ici)
VAL_RATIO=0.2

# Nettoyage
rm -rf "$OUTPUT_DIR"
mkdir -p "$TRAIN_DIR" "$VAL_DIR"

# Pour chaque classe
for class in "$DATASET_DIR"/*; do
  class_name=$(basename "$class")
  mkdir -p "$TRAIN_DIR/$class_name"
  mkdir -p "$VAL_DIR/$class_name"

  # Mélanger les fichiers
  images=("$class"/*.jpg)
  total=${#images[@]}
  val_count=$(printf "%.0f" $(echo "$total * $VAL_RATIO" | bc))

  # Shuffle des indices
  shuffled=($(shuf -i 0-$(($total - 1))))

  for ((i = 0; i < $total; i++)); do
    img="${images[${shuffled[$i]}]}"
    if (( i < val_count )); then
      cp "$img" "$VAL_DIR/$class_name/"
    else
      cp "$img" "$TRAIN_DIR/$class_name/"
    fi
  done
done

echo "Séparation terminée : $(ls $TRAIN_DIR | wc -l) classes traitées."

