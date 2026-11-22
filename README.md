# iac-guard · demo del gate de CI

Repositorio de demostración de la tesis **iac-guard**. Cada pull request ejecuta el workflow
`.github/workflows/iac-guard.yml`, que:

1. Envía el Terraform del PR a la API de iac-guard (solo lectura: no despliega nada).
2. Espera el análisis completo: Checkov, lectura de la nube conectada (drift), RAG con controles
   NIST CSF/SSDF y explicación con IA (Kimi).
3. Aplica el gate con el umbral configurado en el tablero y bloquea el merge si corresponde.
4. Publica los hallazgos en **Security → Code scanning** (SARIF) y registra la ejecución en el tablero.

El Terraform de este repositorio es de ejemplo y nunca se aplica.
