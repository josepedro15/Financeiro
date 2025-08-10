import{j as e}from"./ui-GI4EfHd4.js";import{r as m}from"./vendor-CZTyH7vC.js";import{c as d,u as L,a as T}from"./index-BvGOXHrp.js";import{B as t,C as o,a as $,b as B,c as F,d as V}from"./card-BpR801jA.js";import{B as g}from"./badge-DJPupDGh.js";import{D as p}from"./dollar-sign-Bsq7vIRq.js";import{C as l}from"./check-opzpl_py.js";import{S as N,H as O,Z as U}from"./zap-DFxTuPRJ.js";import{L as Y}from"./lock-CEwzSrfL.js";import{D as G}from"./database-BoM_Yrpv.js";import{C as H,a as X}from"./chevron-up-CIa33IYc.js";import{M as Z}from"./mail-CQyPUlLo.js";import{C as b}from"./clock-ofQLH_kd.js";import{T as v}from"./trending-up-CzWQNV0r.js";import{S as J}from"./shield-D2be08OS.js";import{T as _}from"./triangle-alert-fl8bPFvx.js";import{C as K}from"./circle-check-big-Dtpwsczj.js";import"./supabase-DfbQpoin.js";import"./charts-DE-LwN1H.js";/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const f=d("ArrowRight",[["path",{d:"M5 12h14",key:"1ays0h"}],["path",{d:"m12 5 7 7-7 7",key:"xquz4c"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const Q=d("CircleX",[["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}],["path",{d:"m15 9-6 6",key:"1uzhvr"}],["path",{d:"m9 9 6 6",key:"z0biqf"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const y=d("MessageCircle",[["path",{d:"M7.9 20A9 9 0 1 0 4 16.1L2 22Z",key:"vv11sd"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const w=d("Play",[["polygon",{points:"6 3 20 12 6 21 6 3",key:"1oa8hb"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const W=d("Rocket",[["path",{d:"M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z",key:"m3kijz"}],["path",{d:"m12 15-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z",key:"1fmvmk"}],["path",{d:"M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0",key:"1f8sc4"}],["path",{d:"M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5",key:"qeys4"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const ee=d("Sparkles",[["path",{d:"M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z",key:"4pj2yx"}],["path",{d:"M20 3v4",key:"1olli1"}],["path",{d:"M22 5h-4",key:"1gvqau"}],["path",{d:"M4 17v2",key:"vumght"}],["path",{d:"M5 18H3",key:"zchphs"}]]),ve=()=>{const{user:j,loading:h}=L(),c=T(),[k,C]=m.useState(!1),[u,S]=m.useState(null),[r,q]=m.useState(new Set),i=m.useRef({});if(m.useEffect(()=>{!h&&j&&c("/dashboard")},[j,h,c]),m.useEffect(()=>{const s=()=>{C(window.scrollY>50),Object.keys(i.current).forEach(a=>{const n=i.current[a];if(n){const x=n.getBoundingClientRect();x.top<window.innerHeight*.8&&x.bottom>0&&!r.has(a)&&q(E=>new Set([...E,a]))}})};return window.addEventListener("scroll",s),s(),()=>window.removeEventListener("scroll",s)},[r]),h)return e.jsx("div",{className:"min-h-screen flex items-center justify-center",children:e.jsx("div",{className:"animate-spin rounded-full h-8 w-8 border-b-2 border-primary"})});const z=[{name:"Starter",description:"Ideal para MEI e pequenos negócios",price:"R$ 79,90",period:"/mês",features:["Dashboard financeiro básico","Até 1.000 transações/mês","1 usuário incluído","CRM básico (até 50 clientes)","Relatórios mensais","Suporte por email"],popular:!1,buttonText:"Começar com Starter",buttonVariant:"outline"},{name:"Business",description:"Para empresas em crescimento",price:"R$ 159,90",period:"/mês",features:["Tudo do Starter +","Transações ilimitadas","Até 3 usuários","CRM completo (clientes ilimitados)","Sistema organizacional","Relatórios avançados","Múltiplas contas financeiras"],popular:!0,buttonText:"Começar com Business",buttonVariant:"default"}],A=[{name:"Maria Silva",role:"CEO, Silva Consultoria",content:"O FinanceiroLogotiq revolucionou nossa gestão financeira. Agora temos controle total e economia de 15h por semana.",rating:5},{name:"João Santos",role:"Proprietário, Santos Tech",content:"Sistema intuitivo e completo. O CRM integrado é fantástico para acompanhar nossos clientes.",rating:5},{name:"Ana Costa",role:"Diretora Financeira, Costa & Associados",content:"Relatórios detalhados e dashboard em tempo real. Nossa lucratividade aumentou 30% em 3 meses.",rating:5}],I=[{icon:b,title:"Economize 15h por semana",description:"Automatize processos financeiros e foque no que realmente importa"},{icon:v,title:"Aumente lucro em 25%",description:"Insights em tempo real para tomar decisões mais inteligentes"},{icon:J,title:"100% Seguro e Confiável",description:"Seus dados protegidos com criptografia de ponta a ponta"}],M=[{icon:_,title:"Controle financeiro desorganizado?",description:"Planilhas espalhadas, dados desatualizados, relatórios confusos"},{icon:Q,title:"Perdendo dinheiro sem saber?",description:"Falta de visibilidade sobre receitas, despesas e lucros"},{icon:b,title:"Tempo demais com burocracia?",description:"Processos manuais, relatórios demorados, erros frequentes"}],R=[{icon:K,title:"Tudo organizado em um só lugar",description:"Dashboard unificado com todas as informações financeiras"},{icon:v,title:"Insights em tempo real",description:"Relatórios automáticos e alertas inteligentes"},{icon:U,title:"Automação completa",description:"Processos automatizados que economizam tempo"}],D=[{question:"Como funciona o período de teste gratuito?",answer:"Oferecemos 14 dias de teste gratuito sem compromisso. Você pode testar todas as funcionalidades sem cartão de crédito."},{question:"Posso cancelar a qualquer momento?",answer:"Sim! Você pode cancelar sua assinatura a qualquer momento sem taxas ou multas."},{question:"Meus dados estão seguros?",answer:"Absolutamente! Utilizamos criptografia de ponta a ponta e seguimos todas as normas de segurança e LGPD."},{question:"Oferecem suporte técnico?",answer:"Sim! Oferecemos suporte por email, chat e telefone para todos os planos."}],P=[{number:"500+",label:"Empresas Atendidas"},{number:"15h",label:"Economia Semanal"},{number:"25%",label:"Aumento de Lucro"},{number:"99.9%",label:"Uptime Garantido"}];return e.jsxs("div",{className:"min-h-screen bg-gradient-to-br from-background via-muted/30 to-background",children:[e.jsx("style",{children:`
        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(30px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        @keyframes fadeInLeft {
          from {
            opacity: 0;
            transform: translateX(-30px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
        
        @keyframes fadeInRight {
          from {
            opacity: 0;
            transform: translateX(30px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
        
        @keyframes scaleIn {
          from {
            opacity: 0;
            transform: scale(0.9);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
        
        @keyframes slideInUp {
          from {
            opacity: 0;
            transform: translateY(50px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        @keyframes pulse {
          0%, 100% {
            transform: scale(1);
          }
          50% {
            transform: scale(1.05);
          }
        }
        
        @keyframes float {
          0%, 100% {
            transform: translateY(0px);
          }
          50% {
            transform: translateY(-10px);
          }
        }
        
        @keyframes gradient {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
          100% {
            background-position: 0% 50%;
          }
        }
        
        .animate-fade-in-up {
          animation: fadeInUp 0.8s ease-out forwards;
        }
        
        .animate-fade-in-left {
          animation: fadeInLeft 0.8s ease-out forwards;
        }
        
        .animate-fade-in-right {
          animation: fadeInRight 0.8s ease-out forwards;
        }
        
        .animate-scale-in {
          animation: scaleIn 0.6s ease-out forwards;
        }
        
        .animate-slide-in-up {
          animation: slideInUp 0.8s ease-out forwards;
        }
        
        .animate-pulse-slow {
          animation: pulse 3s ease-in-out infinite;
        }
        
        .animate-float {
          animation: float 3s ease-in-out infinite;
        }
        
        .animate-gradient {
          background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
          background-size: 400% 400%;
          animation: gradient 15s ease infinite;
        }
        
        .opacity-0 {
          opacity: 0;
        }
        
        .opacity-1 {
          opacity: 1;
        }
        
        .transition-all {
          transition: all 0.3s ease;
        }
        
        .hover-scale:hover {
          transform: scale(1.05);
        }
        
        .hover-lift:hover {
          transform: translateY(-5px);
        }
        
        .text-gradient {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }
        
        .text-gradient-2 {
          background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }
        
        .text-gradient-3 {
          background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }
      `}),e.jsx("header",{className:`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${k?"bg-background/95 backdrop-blur-md border-b shadow-lg":"bg-transparent"}`,children:e.jsx("div",{className:"container mx-auto px-4 py-4",children:e.jsxs("div",{className:"flex items-center justify-between",children:[e.jsxs("div",{className:"flex items-center space-x-3",children:[e.jsx("div",{className:"w-10 h-10 bg-gradient-primary rounded-xl flex items-center justify-center",children:e.jsx(p,{className:"w-5 h-5 text-primary-foreground"})}),e.jsx("h1",{className:"text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent",children:"FinanceiroLogotiq"})]}),e.jsxs("div",{className:"flex items-center space-x-4",children:[e.jsx(t,{variant:"ghost",onClick:()=>document.getElementById("pricing")?.scrollIntoView({behavior:"smooth"}),children:"Planos"}),e.jsx(t,{variant:"ghost",onClick:()=>document.getElementById("contact")?.scrollIntoView({behavior:"smooth"}),children:"Contato"}),e.jsx(t,{onClick:()=>c("/auth"),children:"Acessar Sistema"})]})]})})}),e.jsxs("main",{className:"pt-20",children:[e.jsx("section",{className:"container mx-auto px-4 py-20",children:e.jsxs("div",{ref:s=>i.current.hero=s,className:`text-center max-w-4xl mx-auto mb-16 ${r.has("hero")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsxs(g,{className:"mb-4 bg-primary/10 text-primary border-primary/20 animate-pulse-slow",children:[e.jsx(ee,{className:"w-3 h-3 mr-1"}),"Plataforma #1 em Gestão Financeira"]}),e.jsxs("h1",{className:"text-5xl md:text-7xl font-bold mb-6 bg-gradient-primary bg-clip-text text-transparent",children:["Gestão Financeira",e.jsx("br",{}),e.jsx("span",{className:"text-primary",children:"Inteligente"})]}),e.jsx("p",{className:"text-xl text-muted-foreground mb-8 leading-relaxed max-w-2xl mx-auto",children:"Sistema completo para controle financeiro empresarial. Gerencie receitas, despesas, clientes e obtenha insights em tempo real."}),e.jsxs("div",{className:"flex flex-col sm:flex-row gap-4 justify-center mb-8",children:[e.jsxs(t,{size:"lg",className:"text-lg px-8 group hover-scale transition-all",onClick:()=>c("/auth"),children:["Começar Gratuitamente",e.jsx(f,{className:"w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform"})]}),e.jsxs(t,{size:"lg",variant:"outline",className:"text-lg px-8 group hover-scale transition-all",children:[e.jsx(w,{className:"w-4 h-4 mr-2"}),"Ver Demo"]})]}),e.jsxs("div",{className:"flex items-center justify-center space-x-8 text-sm text-muted-foreground",children:[e.jsxs("div",{className:"flex items-center",children:[e.jsx(l,{className:"w-4 h-4 text-success mr-1"}),"14 dias grátis"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(l,{className:"w-4 h-4 text-success mr-1"}),"Sem cartão de crédito"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(l,{className:"w-4 h-4 text-success mr-1"}),"Setup em 2 minutos"]})]})]})}),e.jsx("section",{className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{ref:s=>i.current.problems=s,className:`text-center mb-16 ${r.has("problems")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Problemas que Resolvemos"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Transforme seus desafios em oportunidades"})]}),e.jsxs("div",{className:"grid md:grid-cols-2 gap-16 mb-16",children:[e.jsxs("div",{ref:s=>i.current["problems-left"]=s,className:`${r.has("problems-left")?"animate-fade-in-left":"opacity-0"}`,children:[e.jsx("h3",{className:"text-2xl font-bold mb-8 text-destructive",children:"Antes"}),e.jsx("div",{className:"space-y-6",children:M.map((s,a)=>e.jsxs("div",{className:"flex items-start space-x-4 p-4 rounded-lg bg-destructive/5 border border-destructive/10 hover-lift transition-all hover:shadow-lg",style:{animationDelay:`${a*.2}s`},children:[e.jsx(s.icon,{className:"w-6 h-6 text-destructive mt-1 flex-shrink-0"}),e.jsxs("div",{children:[e.jsx("h4",{className:"font-semibold text-destructive",children:s.title}),e.jsx("p",{className:"text-muted-foreground",children:s.description})]})]},a))})]}),e.jsxs("div",{ref:s=>i.current["solutions-right"]=s,className:`${r.has("solutions-right")?"animate-fade-in-right":"opacity-0"}`,children:[e.jsx("h3",{className:"text-2xl font-bold mb-8 text-success",children:"Depois"}),e.jsx("div",{className:"space-y-6",children:R.map((s,a)=>e.jsxs("div",{className:"flex items-start space-x-4 p-4 rounded-lg bg-success/5 border border-success/10 hover-lift transition-all hover:shadow-lg",style:{animationDelay:`${a*.2}s`},children:[e.jsx(s.icon,{className:"w-6 h-6 text-success mt-1 flex-shrink-0"}),e.jsxs("div",{children:[e.jsx("h4",{className:"font-semibold text-success",children:s.title}),e.jsx("p",{className:"text-muted-foreground",children:s.description})]})]},a))})]})]})]})}),e.jsx("section",{className:"py-20",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{ref:s=>i.current.benefits=s,className:`text-center mb-16 ${r.has("benefits")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Por que escolher o FinanceiroLogotiq?"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Resultados comprovados por centenas de empresas"})]}),e.jsx("div",{className:"grid md:grid-cols-3 gap-8 mb-16",children:I.map((s,a)=>e.jsxs(o,{ref:n=>i.current[`benefit-${a}`]=n,className:`text-center p-6 hover-scale transition-all duration-300 hover:shadow-lg ${r.has(`benefit-${a}`)?"animate-scale-in":"opacity-0"}`,style:{animationDelay:`${a*.2}s`},children:[e.jsx("div",{className:"w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4 animate-float",children:e.jsx(s.icon,{className:"w-8 h-8 text-primary"})}),e.jsx("h3",{className:"text-xl font-semibold mb-2",children:s.title}),e.jsx("p",{className:"text-muted-foreground",children:s.description})]},a))})]})}),e.jsx("section",{className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{className:"text-center mb-16",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Veja o Sistema em Ação"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Dashboard intuitivo e funcionalidades poderosas"})]}),e.jsx("div",{className:"max-w-6xl mx-auto",children:e.jsx(o,{className:"p-8",children:e.jsx("div",{className:"aspect-video bg-gradient-to-br from-primary/10 to-secondary/10 rounded-lg flex items-center justify-center",children:e.jsxs("div",{className:"text-center",children:[e.jsx(w,{className:"w-16 h-16 text-primary mx-auto mb-4"}),e.jsx("p",{className:"text-lg font-semibold",children:"Demo Interativo"}),e.jsx("p",{className:"text-muted-foreground",children:"Clique para ver o sistema funcionando"})]})})})})]})}),e.jsx("section",{className:"py-20",children:e.jsx("div",{className:"container mx-auto px-4",children:e.jsx("div",{className:"grid md:grid-cols-4 gap-8",children:P.map((s,a)=>e.jsxs("div",{className:"text-center",children:[e.jsx("div",{className:"text-4xl font-bold text-primary mb-2",children:s.number}),e.jsx("div",{className:"text-muted-foreground",children:s.label})]},a))})})}),e.jsx("section",{className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{className:"text-center mb-16",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"O que nossos clientes dizem"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Depoimentos reais de quem já transformou sua gestão"})]}),e.jsx("div",{className:"grid md:grid-cols-3 gap-8",children:A.map((s,a)=>e.jsxs(o,{className:"p-6",children:[e.jsx("div",{className:"flex mb-4",children:[...Array(s.rating)].map((n,x)=>e.jsx(N,{className:"w-4 h-4 text-yellow-400 fill-current"},x))}),e.jsxs("p",{className:"text-muted-foreground mb-4 italic",children:['"',s.content,'"']}),e.jsxs("div",{children:[e.jsx("div",{className:"font-semibold",children:s.name}),e.jsx("div",{className:"text-sm text-muted-foreground",children:s.role})]})]},a))})]})}),e.jsx("section",{className:"py-20",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{className:"text-center mb-16",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Segurança e Confiança"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Seus dados protegidos com a mais alta tecnologia"})]}),e.jsxs("div",{className:"grid md:grid-cols-3 gap-8",children:[e.jsxs(o,{className:"text-center p-6",children:[e.jsx(Y,{className:"w-12 h-12 text-primary mx-auto mb-4"}),e.jsx("h3",{className:"text-xl font-semibold mb-2",children:"Criptografia SSL"}),e.jsx("p",{className:"text-muted-foreground",children:"Dados protegidos com criptografia de ponta a ponta"})]}),e.jsxs(o,{className:"text-center p-6",children:[e.jsx(G,{className:"w-12 h-12 text-primary mx-auto mb-4"}),e.jsx("h3",{className:"text-xl font-semibold mb-2",children:"Backup Automático"}),e.jsx("p",{className:"text-muted-foreground",children:"Backup diário automático em servidores seguros"})]}),e.jsxs(o,{className:"text-center p-6",children:[e.jsx(O,{className:"w-12 h-12 text-primary mx-auto mb-4"}),e.jsx("h3",{className:"text-xl font-semibold mb-2",children:"Suporte 24/7"}),e.jsx("p",{className:"text-muted-foreground",children:"Equipe especializada disponível quando você precisar"})]})]})]})}),e.jsx("section",{id:"pricing",className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{className:"text-center mb-16",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Planos e Preços"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Escolha o plano ideal para o seu negócio"})]}),e.jsx("div",{className:"grid md:grid-cols-2 gap-8 max-w-4xl mx-auto",children:z.map(s=>e.jsxs(o,{className:`relative hover:shadow-xl transition-all duration-300 hover:-translate-y-2 ${s.popular?"ring-2 ring-primary":""}`,children:[s.popular&&e.jsxs(g,{className:"absolute -top-3 left-1/2 transform -translate-x-1/2 bg-primary text-primary-foreground",children:[e.jsx(N,{className:"w-3 h-3 mr-1"}),"Mais Popular"]}),e.jsxs($,{className:"text-center pb-4",children:[e.jsx(B,{className:"text-2xl font-bold",children:s.name}),e.jsx(F,{className:"text-base",children:s.description})]}),e.jsxs(V,{className:"space-y-6",children:[e.jsx("div",{className:"text-center",children:e.jsxs("div",{className:"flex items-baseline justify-center",children:[e.jsx("span",{className:"text-4xl font-bold",children:s.price}),e.jsx("span",{className:"text-muted-foreground ml-1",children:s.period})]})}),e.jsx("ul",{className:"space-y-3",children:s.features.map((a,n)=>e.jsxs("li",{className:"flex items-center",children:[e.jsx(l,{className:"w-4 h-4 text-success mr-3 flex-shrink-0"}),e.jsx("span",{className:"text-sm",children:a})]},n))}),e.jsxs(t,{variant:s.buttonVariant,className:"w-full group",size:"lg",onClick:()=>c("/auth"),children:[s.buttonText,e.jsx(f,{className:"w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform"})]})]})]},s.name))})]})}),e.jsx("section",{className:"py-20",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{className:"text-center mb-16",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Perguntas Frequentes"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Tire suas dúvidas sobre nossa plataforma"})]}),e.jsx("div",{className:"max-w-3xl mx-auto space-y-4",children:D.map((s,a)=>e.jsxs(o,{className:"overflow-hidden",children:[e.jsxs("button",{className:"w-full p-6 text-left flex items-center justify-between hover:bg-muted/50 transition-colors",onClick:()=>S(u===a?null:a),children:[e.jsx("h3",{className:"font-semibold",children:s.question}),u===a?e.jsx(H,{className:"w-5 h-5 text-muted-foreground"}):e.jsx(X,{className:"w-5 h-5 text-muted-foreground"})]}),u===a&&e.jsx("div",{className:"px-6 pb-6",children:e.jsx("p",{className:"text-muted-foreground",children:s.answer})})]},a))})]})}),e.jsx("section",{className:"py-20 bg-primary text-primary-foreground",children:e.jsxs("div",{className:"container mx-auto px-4 text-center",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Pronto para transformar sua gestão financeira?"}),e.jsx("p",{className:"text-xl mb-8 opacity-90",children:"Junte-se a centenas de empresas que já revolucionaram suas finanças"}),e.jsxs("div",{className:"flex flex-col sm:flex-row gap-4 justify-center",children:[e.jsxs(t,{size:"lg",variant:"secondary",className:"text-lg px-8 group",onClick:()=>c("/auth"),children:[e.jsx(W,{className:"w-4 h-4 mr-2"}),"Começar Gratuitamente",e.jsx(f,{className:"w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform"})]}),e.jsxs(t,{size:"lg",variant:"outline",className:"text-lg px-8 border-primary-foreground text-primary-foreground hover:bg-primary-foreground hover:text-primary",children:[e.jsx(y,{className:"w-4 h-4 mr-2"}),"Falar com Especialista"]})]}),e.jsxs("div",{className:"mt-8 flex items-center justify-center space-x-8 text-sm opacity-75",children:[e.jsxs("div",{className:"flex items-center",children:[e.jsx(l,{className:"w-4 h-4 mr-1"}),"14 dias grátis"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(l,{className:"w-4 h-4 mr-1"}),"Sem cartão de crédito"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(l,{className:"w-4 h-4 mr-1"}),"Cancelamento gratuito"]})]})]})})]}),e.jsx("footer",{id:"contact",className:"border-t bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4 py-12",children:[e.jsxs("div",{className:"grid md:grid-cols-4 gap-8 mb-8",children:[e.jsxs("div",{children:[e.jsxs("div",{className:"flex items-center space-x-3 mb-4",children:[e.jsx("div",{className:"w-8 h-8 bg-gradient-primary rounded-lg flex items-center justify-center",children:e.jsx(p,{className:"w-4 h-4 text-primary-foreground"})}),e.jsx("span",{className:"text-lg font-bold",children:"FinanceiroLogotiq"})]}),e.jsx("p",{className:"text-muted-foreground mb-4",children:"A plataforma mais completa para gestão financeira empresarial."}),e.jsxs("div",{className:"flex space-x-4",children:[e.jsx(t,{variant:"ghost",size:"sm",children:e.jsx(Z,{className:"w-4 h-4"})}),e.jsx(t,{variant:"ghost",size:"sm",children:e.jsx(y,{className:"w-4 h-4"})})]})]}),e.jsxs("div",{children:[e.jsx("h3",{className:"font-semibold mb-4",children:"Produto"}),e.jsxs("ul",{className:"space-y-2 text-muted-foreground",children:[e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Dashboard"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"CRM"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Relatórios"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Integrações"})})]})]}),e.jsxs("div",{children:[e.jsx("h3",{className:"font-semibold mb-4",children:"Empresa"}),e.jsxs("ul",{className:"space-y-2 text-muted-foreground",children:[e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Sobre nós"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Carreiras"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Blog"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Imprensa"})})]})]}),e.jsxs("div",{children:[e.jsx("h3",{className:"font-semibold mb-4",children:"Suporte"}),e.jsxs("ul",{className:"space-y-2 text-muted-foreground",children:[e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Central de Ajuda"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Contato"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Status"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Documentação"})})]})]})]}),e.jsxs("div",{className:"border-t pt-8 flex flex-col md:flex-row items-center justify-between",children:[e.jsxs("div",{className:"flex items-center space-x-3 mb-4 md:mb-0",children:[e.jsx("div",{className:"w-6 h-6 bg-gradient-primary rounded flex items-center justify-center",children:e.jsx(p,{className:"w-3 h-3 text-primary-foreground"})}),e.jsx("span",{className:"text-sm text-muted-foreground",children:"© 2024 FinanceiroLogotiq. Todos os direitos reservados."})]}),e.jsxs("div",{className:"flex space-x-6 text-sm text-muted-foreground",children:[e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Privacidade"}),e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Termos"}),e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Cookies"})]})]})]})})]})};export{ve as default};
