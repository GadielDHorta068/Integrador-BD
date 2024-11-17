import csv
import sys

def csv_to_markdown(csv_file, markdown_file):
    with open(csv_file, 'r') as csvfile:
        reader = csv.reader(csvfile)
        rows = list(reader)

    with open(markdown_file, 'w') as mdfile:
        # Escribir encabezados
        mdfile.write('| ' + ' | '.join(rows[0]) + ' |\n')
        mdfile.write('| ' + ' | '.join(['-' * len(col) for col in rows[0]]) + ' |\n')
        # Escribir filas
        for row in rows[1:]:
            mdfile.write('| ' + ' | '.join(row) + ' |\n')

# Leer argumentos de la terminal
if len(sys.argv) != 3:
    print("Uso: python3 csv_to_markdown.py <archivo_csv> <archivo_md>")
    sys.exit(1)

csv_file = sys.argv[1]
markdown_file = sys.argv[2]

csv_to_markdown(csv_file, markdown_file)
