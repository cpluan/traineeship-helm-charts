from robusta.core.reporting.blocks import MarkdownBlock
import requests

def custom_ai_explainer(event):
    alert = event.get_alert()
    prompt = f"Explique este alerta Kubernetes:\n\nNome: {alert.name}\nDescrição: {alert.description or alert.summary}\nSeveridade: {alert.severity}"
    try:
        response = requests.post("http://localhost:11434/api/generate", json={
            "model": "llama3",
            "prompt": prompt,
            "stream": False
        })
        explanation = response.json().get("response", "Sem resposta da IA")
    except Exception as e:
        explanation = f"Erro ao consultar IA local: {e}"

    event.add_enrichment([
        MarkdownBlock(f"💡 Explicação da IA local:\n\n{explanation}")
    ])
