# Down-QA

`down-qa` e a fase pos-implementacao do sdd-lite. Ela valida se o
produto implementado cumpre o `spec.md` usando evidencia de execucao, de
preferencia via navegador real.

## Principios

- Read-only por padrao: nao editar codigo, specs, fixtures ou dados permanentes.
- Spec primeiro: extrair criterios observaveis antes de navegar.
- Evidencia antes de confianca: cada PASS/FAIL precisa de acao, URL, DOM,
  screenshot, log ou erro concreto.
- Browser real quando o fluxo for web. Leitura de codigo nao substitui teste de
  fluxo.
- Falhas de ambiente sao `BLOCKED`, nao PASS inferido.

## Entradas

- Obrigatoria: `sdd-docs/<slug>/YYYY-MM-DD-spec.md`.
- Obrigatoria para web: URL inicial ou comando para subir o app.
- Opcional: escopo de features, por exemplo "teste F1 e F3".
- Opcional: dados de teste e credenciais fornecidos pelo usuario.

Se faltar URL, comando de dev server, dados obrigatorios ou credencial, pare e
pergunte somente pelo minimo necessario.

## Browser Capability Check

Antes de testar fluxo web, o agente deve diagnosticar o harness:

1. Procurar setup existente do projeto: `package.json`, scripts, Playwright,
   framework de teste ou docs locais.
2. Verificar runtime disponivel: `node --version`, `npm --version`,
   `command -v npx`.
3. Tentar Playwright do projeto ou runtime bundled quando existir.
4. Se browsers do Playwright faltarem, rodar ou solicitar permissao para
   `npx playwright install` quando apropriado.
5. Se download nao for possivel, tentar Chrome/Edge do sistema por canal.
6. Se GUI for bloqueada, tentar headless; se headed for essencial, pedir
   permissao.
7. Se nada funcionar, emitir `Browser Harness: BLOCKED` com comando e erro.

O agente nunca deve marcar teste de browser como concluido se o browser nao foi
de fato exercitado.

## Fluxo

1. Leia o `spec.md` e extraia uma checklist por feature numerada.
2. Identifique criterios de aceite testaveis e dados necessarios.
3. Suba ou localize o app sem mudar configuracoes permanentes.
4. Execute os fluxos no navegador como usuario real.
5. Compare comportamento observado contra cada criterio.
6. Grave `sdd-docs/<slug>/YYYY-MM-DD-down-qa-report.md`.
7. Se houver bloqueio, registre exatamente o que falta para destravar.

## Vereditos

- `PASS`: criterios testados cumprem a spec.
- `PARTIAL`: parte cumpre, mas ha gaps, risco ou escopo nao coberto.
- `FAIL`: comportamento contradiz criterio obrigatorio da spec.
- `BLOCKED`: ambiente, dados, auth ou browser impediram teste responsavel.

## Browser Harness

- `READY`: automacao de browser funcionou normalmente.
- `DEGRADED`: teste executado com fallback, como Chrome do sistema em vez de
  Chromium bundled.
- `BLOCKED`: nao foi possivel lancar, navegar ou interagir; incluir erro.

## Saida

Use `sdd-templates/down-qa-report.md`. O relatorio e um artefato de
evidencia; nao edite `spec.md` nem arquivos de implementacao durante esta fase.
