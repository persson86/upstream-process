# Proposal: bookmarks-cli

## Problema/Oportunidade

Salvo links uteis em lugares dispersos (abas, notas soltas, mensagens pra mim mesmo) e nunca reencontro. Quero um jeito rapido, via terminal, de salvar um link com tags e reencontrar depois — sem depender de servico web ou conta.

## Contexto

- Situacao atual: links espalhados; busca manual; perda frequente.
- Usuario/publico afetado: eu (uso pessoal, single-user, local).
- Restricoes relevantes: offline-first; sem backend; armazenamento local simples; CLI.
- O que esta fora de escopo: sync entre maquinas, UI grafica, multiusuario.

## Evidencia

- Observacao propria: ~5 links/dia que gostaria de reencontrar; hoje reencontro talvez 1.
- Hipotese: tag + busca por substring resolve 80% dos casos.

## Opcoes Consideradas

1. **Extensao de navegador** — captura facil, mas preso ao browser e fora do meu fluxo de terminal.
2. **Arquivo markdown editado a mao** — zero codigo, mas busca/formatacao viram bagunca rapido.
3. **CLI com store local (JSON/SQLite)** — cabe no fluxo terminal, busca estruturada; precisa de um pouco de codigo. **(recomendada)**

## Proposta Recomendada

Uma CLI minima `bm` com tres acoes: adicionar link (com tags), listar/buscar por tag ou texto, e remover. Store local em arquivo unico. Menor recorte util: `add`, `list`, `find`. Resultado esperado: reencontrar um link salvo em < 5s.

## Riscos & Assuncoes Abertas

- **Risco:** crescer de escopo para "gerenciador de conhecimento". - mitigacao: travar nas 3 acoes.
- **Assuncao:** store em JSON unico aguenta o volume pessoal. - validar: ok ate ~10k entradas; revisitar depois.

## Sinal De Pronto Para Spec

O proposal esta pronto para `@up-spec`: proposta recomendada, escopo inicial (add/list/find) e assuncoes principais estao claros o suficiente para gerar criterios de aceite testaveis.
