import os

directory = ".\hijackrcc"
output_qrc = "resources.qrc"

with open(output_qrc, "w") as qrc_file:
    qrc_file.write('<RCC>\n  <qresource prefix="/">\n')
    for root, dirs, files in os.walk(directory):
        for file in files:
            full_path = os.path.join(root, file).replace("\\", "/")
            relative_path = os.path.relpath(full_path, directory).replace("\\", "/")
            qrc_file.write(f'    <file>{relative_path}</file>\n')
    qrc_file.write('  </qresource>\n</RCC>\n')

print(f"Generated {output_qrc}")
