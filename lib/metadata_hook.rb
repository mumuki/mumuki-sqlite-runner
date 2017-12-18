class SqliteMetadataHook < Mumukit::Hook
  def metadata
    {
      language: {
        name: 'sqlite',
        icon: { type: 'devicon', name: 'sql' },
        version: '3.13.0',
        extension: 'sql',
        ace_mode: 'sql',
        graphic: true
      },
      test_framework: {
        name: 'metatest',
        test_extension: 'yml',
        template: template
      }
    }
  end

  def template
    <<YAML
# El siguiente es un ejemplo de cómo generar test para SQL utilizando formato YAML.
# Acá dejamos los tres tipos de tests que podés escribir.
# Para info más detallada revisá la wiki: https://github.com/mumuki/mumuki-sqlite-runner/wiki

# 1. query
- type: query
  seed: | # Opcional
    INSERT INTO table VALUES ('dato 1');
    INSERT INTO table VALUES ('dato 2');
  expected: SELECT * FROM table;
# 2. datasets
- type: datasets
  seed: | # Opcional
    INSERT INTO table VALUES ('dato 1');
    INSERT INTO table VALUES ('dato 2');
  expected: |
    id|descrip
    1|dato 1
    2|dato 2
# 3. final_dataset
- type: final_dataset
  seed: | # Opcional
    INSERT INTO table VALUES ('dato 1');
    INSERT INTO table VALUES ('dato 2');
  final: SELECT descrip FROM bolitas;
  # Supongamos que el ejercicio pide insertar 'dato 3'
  expected: |
    descrip
    dato 1
    dato 2
    dato 3
YAML
  end
end
