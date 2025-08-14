# 🔄 Forçar Redeploy no Vercel

## 🚨 Problema Identificado
O deploy atual no Vercel está com erro 404 (DEPLOYMENT_NOT_FOUND). Precisamos forçar um novo deploy.

## 🔧 Soluções

### Opção 1: Via GitHub (Recomendado)
1. **Faça um commit vazio** para forçar o deploy:
```bash
git commit --allow-empty -m "force redeploy"
git push
```

### Opção 2: Via Vercel Dashboard
1. **Acesse**: https://vercel.com/dashboard
2. **Selecione o projeto**: `financeiro-7`
3. **Vá em**: Deployments
4. **Clique em**: "Redeploy" no último deploy

### Opção 3: Via Vercel CLI
```bash
# Instalar Vercel CLI
npm install -g vercel

# Fazer login
vercel login

# Deploy manual
vercel --prod
```

## 📋 Verificações

### 1. Verificar Build Local
```bash
# Testar build localmente
npm run build

# Verificar se a pasta dist foi criada
ls -la dist/
```

### 2. Verificar Configurações
- ✅ `vercel.json` configurado
- ✅ `package.json` com scripts corretos
- ✅ Dependências instaladas

### 3. Verificar Variáveis de Ambiente
No Vercel Dashboard:
- **VITE_SITE_URL**: `https://financeiro-7.vercel.app`
- **VITE_SUPABASE_URL**: `https://knbldcvwdpavelmbmdre.supabase.co`
- **VITE_SUPABASE_ANON_KEY**: [sua chave]

## 🎯 Próximos Passos

1. **Force o redeploy** usando uma das opções acima
2. **Aguarde o deploy** completar
3. **Teste a URL**: https://financeiro-7.vercel.app
4. **Configure o Supabase** com a URL correta
5. **Teste os convites** de compartilhamento

## 🔍 Debug

Se o problema persistir:
1. **Verifique os logs** no Vercel Dashboard
2. **Teste build local**: `npm run build`
3. **Verifique dependências**: `npm install`
4. **Limpe cache**: `npm run build -- --force`
