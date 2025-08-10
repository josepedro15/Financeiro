import{j as e}from"./ui-DjOJwOSE.js";import{r}from"./vendor-CZTyH7vC.js";import{c as h,u as Z,a as J,S as M,C as _,B as n,b as A,d as f,e as K,f as Q,g as W,h as ee}from"./index-cimFaT6U.js";import{C as N}from"./clock-scAmddep.js";import{T as v}from"./trending-up-CghpPVsn.js";import{T as se}from"./triangle-alert-0LpMJgCq.js";import{C as ae}from"./circle-x-DUWHR__7.js";import{Z as te,S as z}from"./zap-CuXaZ-H0.js";import{U as re}from"./users-ClPvINpi.js";import{D as y}from"./dollar-sign-_PA37TXE.js";import{C as c}from"./check-CoZWyH6i.js";import{C as ie,a as oe}from"./chevron-up-Dj4W2UXW.js";import{M as ne}from"./mail-CZy2WyuK.js";import"./supabase-DfbQpoin.js";import"./charts-DE-LwN1H.js";/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const w=h("ArrowRight",[["path",{d:"M5 12h14",key:"1ays0h"}],["path",{d:"m12 5 7 7-7 7",key:"xquz4c"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const I=h("MessageCircle",[["path",{d:"M7.9 20A9 9 0 1 0 4 16.1L2 22Z",key:"vv11sd"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const le=h("Play",[["polygon",{points:"6 3 20 12 6 21 6 3",key:"1oa8hb"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const ce=h("Rocket",[["path",{d:"M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z",key:"m3kijz"}],["path",{d:"m12 15-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z",key:"1fmvmk"}],["path",{d:"M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0",key:"1f8sc4"}],["path",{d:"M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5",key:"qeys4"}]]);/**
 * @license lucide-react v0.462.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const me=h("Sparkles",[["path",{d:"M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z",key:"4pj2yx"}],["path",{d:"M20 3v4",key:"1olli1"}],["path",{d:"M22 5h-4",key:"1gvqau"}],["path",{d:"M4 17v2",key:"vumght"}],["path",{d:"M5 18H3",key:"zchphs"}]]),Me=()=>{const{user:m,loading:R}=Z(),x=J(),[$,D]=r.useState(!1),[g,P]=r.useState(null),[i,T]=r.useState(new Set),[j,k]=r.useState({}),o=r.useRef({}),E=r.useCallback((s,a)=>{let t;return function(){const l=arguments,u=this;t||(s.apply(u,l),t=!0,setTimeout(()=>t=!1,a))}},[]);if(r.useEffect(()=>{const s=E(()=>{D(window.scrollY>50);const a=Object.keys(o.current);for(let t=0;t<a.length;t++){const l=a[t],u=o.current[l];if(u&&!i.has(l)){const S=u.getBoundingClientRect();S.top<window.innerHeight*.8&&S.bottom>0&&(T(d=>new Set([...d,l])),l==="metrics"&&!j.initialized&&(C.forEach((d,xe)=>{const b=parseInt(d.number.replace(/\D/g,"")),G=1500,q=30,Y=b/q;let p=0;const X=setInterval(()=>{p+=Y,p>=b&&(p=b,clearInterval(X)),k(H=>({...H,[d.number]:Math.floor(p)}))},G/q)}),k(d=>({...d,initialized:!0}))))}}},16);return window.addEventListener("scroll",s,{passive:!0}),s(),()=>window.removeEventListener("scroll",s)},[i,j.initialized]),R)return e.jsx("div",{className:"min-h-screen flex items-center justify-center",children:e.jsx("div",{className:"animate-spin rounded-full h-8 w-8 border-b-2 border-primary"})});const L=r.useMemo(()=>[{name:"Starter",description:"Ideal para MEI e pequenos negócios",price:"R$ 79,90",period:"/mês",features:["Dashboard financeiro básico","Até 1.000 transações/mês","1 usuário incluído","CRM básico (até 50 clientes)","Relatórios mensais","Suporte por email"],popular:!1,buttonText:"Começar com Starter",buttonVariant:"outline"},{name:"Business",description:"Para empresas em crescimento",price:"R$ 159,90",period:"/mês",features:["Tudo do Starter +","Transações ilimitadas","Até 3 usuários","CRM completo (clientes ilimitados)","Sistema organizacional","Relatórios avançados","Múltiplas contas financeiras"],popular:!0,buttonText:"Começar com Business",buttonVariant:"default"}],[]),F=r.useMemo(()=>[{name:"Maria Silva",role:"CEO, Silva Consultoria",content:"O FinanceiroLogotiq revolucionou nossa gestão financeira. Agora temos controle total e economia de 15h por semana.",rating:5},{name:"João Santos",role:"Proprietário, Santos Tech",content:"Sistema intuitivo e completo. O CRM integrado é fantástico para acompanhar nossos clientes.",rating:5},{name:"Ana Costa",role:"Diretora Financeira, Costa & Associados",content:"Relatórios detalhados e dashboard em tempo real. Nossa lucratividade aumentou 30% em 3 meses.",rating:5}],[]),B=r.useMemo(()=>[{icon:N,title:"Economize 15h por semana",description:"Automatize processos financeiros e foque no que realmente importa"},{icon:v,title:"Aumente lucro em 25%",description:"Insights em tempo real para tomar decisões mais inteligentes"},{icon:M,title:"100% Seguro e Confiável",description:"Seus dados protegidos com criptografia de ponta a ponta"}],[]),U=r.useMemo(()=>[{icon:se,title:"Controle financeiro desorganizado?",description:"Planilhas espalhadas, dados desatualizados, relatórios confusos"},{icon:ae,title:"Perdendo dinheiro sem saber?",description:"Falta de visibilidade sobre receitas, despesas e lucros"},{icon:N,title:"Tempo demais com burocracia?",description:"Processos manuais, relatórios demorados, erros frequentes"}],[]),V=r.useMemo(()=>[{icon:_,title:"Tudo organizado em um só lugar",description:"Dashboard unificado com todas as informações financeiras"},{icon:v,title:"Insights em tempo real",description:"Relatórios automáticos e alertas inteligentes"},{icon:te,title:"Automação completa",description:"Processos automatizados que economizam tempo"}],[]),O=r.useMemo(()=>[{question:"Como funciona o período de teste gratuito?",answer:"Oferecemos 14 dias de teste gratuito sem compromisso. Você pode testar todas as funcionalidades sem cartão de crédito."},{question:"Posso cancelar a qualquer momento?",answer:"Sim! Você pode cancelar sua assinatura a qualquer momento sem taxas ou multas."},{question:"Meus dados estão seguros?",answer:"Absolutamente! Utilizamos criptografia de ponta a ponta e seguimos todas as normas de segurança e LGPD."},{question:"Oferecem suporte técnico?",answer:"Sim! Oferecemos suporte por email, chat e telefone para todos os planos."}],[]),C=r.useMemo(()=>[{number:"500+",label:"Empresas Atendidas",icon:re},{number:"15h",label:"Economia Semanal",icon:N},{number:"25%",label:"Aumento de Lucro",icon:v},{number:"99.9%",label:"Uptime Garantido",icon:M}],[]);return e.jsxs("div",{className:"min-h-screen bg-gradient-to-br from-background via-muted/30 to-background",children:[e.jsx("style",{children:`
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
      `}),e.jsx("header",{className:`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${$?"bg-background/95 backdrop-blur-md border-b shadow-lg":"bg-transparent"}`,children:e.jsx("div",{className:"container mx-auto px-4 py-4",children:e.jsxs("div",{className:"flex items-center justify-between",children:[e.jsx("div",{className:"flex items-center space-x-3",children:e.jsx(n,{variant:"ghost",className:"p-0 h-auto hover:bg-transparent",onClick:()=>x("/"),children:e.jsxs("div",{className:"flex items-center space-x-3",children:[e.jsx("div",{className:"w-10 h-10 bg-gradient-primary rounded-xl flex items-center justify-center",children:e.jsx(y,{className:"w-5 h-5 text-primary-foreground"})}),e.jsx("h1",{className:"text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent",children:"FinanceiroLogotiq"})]})})}),e.jsxs("div",{className:"flex items-center space-x-4",children:[e.jsx(n,{variant:"ghost",onClick:()=>document.getElementById("pricing")?.scrollIntoView({behavior:"smooth"}),children:"Planos"}),e.jsx(n,{variant:"ghost",onClick:()=>document.getElementById("contact")?.scrollIntoView({behavior:"smooth"}),children:"Contato"}),e.jsx(n,{onClick:()=>x(m?"/dashboard":"/auth"),children:m?"Dashboard":"Acessar Sistema"})]})]})})}),e.jsxs("main",{className:"pt-20",children:[e.jsx("section",{className:"container mx-auto px-4 py-20",children:e.jsxs("div",{ref:s=>o.current.hero=s,className:`text-center max-w-4xl mx-auto mb-16 ${i.has("hero")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsxs(A,{className:"mb-4 bg-primary/10 text-primary border-primary/20 animate-pulse-slow",children:[e.jsx(me,{className:"w-3 h-3 mr-1"}),"Plataforma #1 em Gestão Financeira"]}),e.jsxs("h1",{className:"text-5xl md:text-7xl font-bold mb-6 bg-gradient-primary bg-clip-text text-transparent",children:["Gestão Financeira",e.jsx("br",{}),e.jsx("span",{className:"text-primary",children:"Inteligente"})]}),e.jsx("p",{className:"text-xl text-muted-foreground mb-8 leading-relaxed max-w-2xl mx-auto",children:"Sistema completo para controle financeiro empresarial. Gerencie receitas, despesas, clientes e obtenha insights em tempo real."}),e.jsxs("div",{className:"flex flex-col sm:flex-row gap-4 justify-center mb-8",children:[e.jsxs(n,{size:"lg",className:"text-lg px-8 group hover-scale transition-all",onClick:()=>x(m?"/dashboard":"/auth"),children:[m?"Acessar Dashboard":"Começar Gratuitamente",e.jsx(w,{className:"w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform"})]}),e.jsxs(n,{size:"lg",variant:"outline",className:"text-lg px-8 group hover-scale transition-all",children:[e.jsx(le,{className:"w-4 h-4 mr-2"}),"Ver Demo"]})]}),e.jsxs("div",{className:"flex items-center justify-center space-x-8 text-sm text-muted-foreground",children:[e.jsxs("div",{className:"flex items-center",children:[e.jsx(c,{className:"w-4 h-4 text-success mr-1"}),"14 dias grátis"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(c,{className:"w-4 h-4 text-success mr-1"}),"Sem cartão de crédito"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(c,{className:"w-4 h-4 text-success mr-1"}),"Setup em 2 minutos"]})]})]})}),e.jsx("section",{className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{ref:s=>o.current.problems=s,className:`text-center mb-16 ${i.has("problems")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Problemas que Resolvemos"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Transforme seus desafios em oportunidades"})]}),e.jsxs("div",{className:"grid md:grid-cols-2 gap-16 mb-16",children:[e.jsxs("div",{ref:s=>o.current["problems-left"]=s,className:`${i.has("problems-left")?"animate-fade-in-left":"opacity-0"}`,children:[e.jsx("h3",{className:"text-2xl font-bold mb-8 text-destructive",children:"Antes"}),e.jsx("div",{className:"space-y-6",children:U.map((s,a)=>e.jsxs("div",{className:"flex items-start space-x-4 p-4 rounded-lg bg-destructive/5 border border-destructive/10 hover-lift transition-all hover:shadow-lg",style:{animationDelay:`${a*.2}s`},children:[e.jsx(s.icon,{className:"w-6 h-6 text-destructive mt-1 flex-shrink-0"}),e.jsxs("div",{children:[e.jsx("h4",{className:"font-semibold text-destructive",children:s.title}),e.jsx("p",{className:"text-muted-foreground",children:s.description})]})]},a))})]}),e.jsxs("div",{ref:s=>o.current["solutions-right"]=s,className:`${i.has("solutions-right")?"animate-fade-in-right":"opacity-0"}`,children:[e.jsx("h3",{className:"text-2xl font-bold mb-8 text-success",children:"Depois"}),e.jsx("div",{className:"space-y-6",children:V.map((s,a)=>e.jsxs("div",{className:"flex items-start space-x-4 p-4 rounded-lg bg-success/5 border border-success/10 hover-lift transition-all hover:shadow-lg",style:{animationDelay:`${a*.2}s`},children:[e.jsx(s.icon,{className:"w-6 h-6 text-success mt-1 flex-shrink-0"}),e.jsxs("div",{children:[e.jsx("h4",{className:"font-semibold text-success",children:s.title}),e.jsx("p",{className:"text-muted-foreground",children:s.description})]})]},a))})]})]})]})}),e.jsx("section",{className:"py-20",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{ref:s=>o.current.benefits=s,className:`text-center mb-16 ${i.has("benefits")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Por que escolher o FinanceiroLogotiq?"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Resultados comprovados por centenas de empresas"})]}),e.jsx("div",{className:"grid md:grid-cols-3 gap-8 mb-16",children:B.map((s,a)=>e.jsxs(f,{ref:t=>o.current[`benefit-${a}`]=t,className:`text-center p-6 hover-scale transition-all duration-300 hover:shadow-lg ${i.has(`benefit-${a}`)?"animate-scale-in":"opacity-0"}`,style:{animationDelay:`${a*.2}s`},children:[e.jsx("div",{className:"w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4 animate-float",children:e.jsx(s.icon,{className:"w-8 h-8 text-primary"})}),e.jsx("h3",{className:"text-xl font-semibold mb-2",children:s.title}),e.jsx("p",{className:"text-muted-foreground",children:s.description})]},a))})]})}),e.jsx("section",{className:"py-16",children:e.jsxs("div",{className:"container mx-auto px-4 text-center",children:[e.jsx("h2",{className:"text-2xl font-bold mb-4",children:"Funcionalidades Completas"}),e.jsx("p",{className:"text-muted-foreground mb-8",children:"Dashboard intuitivo, CRM integrado, relatórios automáticos, segurança total e automação inteligente"})]})}),e.jsx("section",{className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{ref:s=>o.current.metrics=s,className:`text-center mb-16 ${i.has("metrics")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Números que Impressionam"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Resultados reais de empresas que confiam em nós"})]}),e.jsx("div",{className:"grid md:grid-cols-4 gap-8",children:C.map((s,a)=>e.jsxs("div",{ref:t=>o.current[`metric-${a}`]=t,className:`text-center p-6 rounded-lg bg-white shadow-lg hover-lift transition-all ${i.has(`metric-${a}`)?"animate-scale-in":"opacity-0"}`,style:{animationDelay:`${a*.2}s`},children:[e.jsx("div",{className:"w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4",children:e.jsx(s.icon,{className:"w-8 h-8 text-primary"})}),e.jsxs("div",{className:"text-4xl font-bold text-primary mb-2",children:[j[s.number]||0,s.number.includes("+")&&"+",s.number.includes("%")&&"%",s.number.includes("h")&&"h"]}),e.jsx("div",{className:"text-muted-foreground font-medium",children:s.label})]},a))})]})}),e.jsx("section",{className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{ref:s=>o.current.testimonials=s,className:`text-center mb-16 ${i.has("testimonials")?"animate-fade-in-up":"opacity-0"}`,children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"O que nossos clientes dizem"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Depoimentos reais de quem já transformou sua gestão"})]}),e.jsx("div",{className:"grid md:grid-cols-3 gap-8",children:F.map((s,a)=>e.jsxs(f,{ref:t=>o.current[`testimonial-${a}`]=t,className:`p-6 hover-lift transition-all ${i.has(`testimonial-${a}`)?"animate-scale-in":"opacity-0"}`,style:{animationDelay:`${a*.2}s`},children:[e.jsx("div",{className:"flex mb-4",children:[...Array(s.rating)].map((t,l)=>e.jsx(z,{className:"w-4 h-4 text-yellow-400 fill-current"},l))}),e.jsxs("p",{className:"text-muted-foreground mb-4 italic",children:['"',s.content,'"']}),e.jsxs("div",{children:[e.jsx("div",{className:"font-semibold",children:s.name}),e.jsx("div",{className:"text-sm text-muted-foreground",children:s.role})]})]},a))})]})}),e.jsx("section",{className:"py-16 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4 text-center",children:[e.jsx("h2",{className:"text-2xl font-bold mb-4",children:"Segurança e Confiança"}),e.jsx("p",{className:"text-muted-foreground mb-8",children:"Seus dados protegidos com criptografia SSL, backup automático e conformidade LGPD"})]})}),e.jsx("section",{id:"pricing",className:"py-20 bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{className:"text-center mb-16",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Planos e Preços"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Escolha o plano ideal para o seu negócio"})]}),e.jsx("div",{className:"grid md:grid-cols-2 gap-8 max-w-4xl mx-auto",children:L.map(s=>e.jsxs(f,{className:`relative hover:shadow-xl transition-all duration-300 hover:-translate-y-2 ${s.popular?"ring-2 ring-primary":""}`,children:[s.popular&&e.jsxs(A,{className:"absolute -top-3 left-1/2 transform -translate-x-1/2 bg-primary text-primary-foreground",children:[e.jsx(z,{className:"w-3 h-3 mr-1"}),"Mais Popular"]}),e.jsxs(K,{className:"text-center pb-4",children:[e.jsx(Q,{className:"text-2xl font-bold",children:s.name}),e.jsx(W,{className:"text-base",children:s.description})]}),e.jsxs(ee,{className:"space-y-6",children:[e.jsx("div",{className:"text-center",children:e.jsxs("div",{className:"flex items-baseline justify-center",children:[e.jsx("span",{className:"text-4xl font-bold",children:s.price}),e.jsx("span",{className:"text-muted-foreground ml-1",children:s.period})]})}),e.jsx("ul",{className:"space-y-3",children:s.features.map((a,t)=>e.jsxs("li",{className:"flex items-center",children:[e.jsx(c,{className:"w-4 h-4 text-success mr-3 flex-shrink-0"}),e.jsx("span",{className:"text-sm",children:a})]},t))}),e.jsxs(n,{variant:s.buttonVariant,className:"w-full group",size:"lg",onClick:()=>x("/auth"),children:[s.buttonText,e.jsx(w,{className:"w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform"})]})]})]},s.name))})]})}),e.jsx("section",{className:"py-20",children:e.jsxs("div",{className:"container mx-auto px-4",children:[e.jsxs("div",{className:"text-center mb-16",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Perguntas Frequentes"}),e.jsx("p",{className:"text-xl text-muted-foreground",children:"Tire suas dúvidas sobre nossa plataforma"})]}),e.jsx("div",{className:"max-w-3xl mx-auto space-y-4",children:O.map((s,a)=>e.jsxs(f,{className:"overflow-hidden",children:[e.jsxs("button",{className:"w-full p-6 text-left flex items-center justify-between hover:bg-muted/50 transition-colors",onClick:()=>P(g===a?null:a),children:[e.jsx("h3",{className:"font-semibold",children:s.question}),g===a?e.jsx(ie,{className:"w-5 h-5 text-muted-foreground"}):e.jsx(oe,{className:"w-5 h-5 text-muted-foreground"})]}),g===a&&e.jsx("div",{className:"px-6 pb-6",children:e.jsx("p",{className:"text-muted-foreground",children:s.answer})})]},a))})]})}),e.jsx("section",{className:"py-20 bg-primary text-primary-foreground",children:e.jsxs("div",{className:"container mx-auto px-4 text-center",children:[e.jsx("h2",{className:"text-3xl font-bold mb-4",children:"Pronto para transformar sua gestão financeira?"}),e.jsx("p",{className:"text-xl mb-8 opacity-90",children:"Junte-se a centenas de empresas que já revolucionaram suas finanças"}),e.jsxs("div",{className:"flex flex-col sm:flex-row gap-4 justify-center",children:[e.jsxs(n,{size:"lg",variant:"secondary",className:"text-lg px-8 group",onClick:()=>x(m?"/dashboard":"/auth"),children:[e.jsx(ce,{className:"w-4 h-4 mr-2"}),m?"Acessar Dashboard":"Começar Gratuitamente",e.jsx(w,{className:"w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform"})]}),e.jsxs(n,{size:"lg",variant:"outline",className:"text-lg px-8 border-primary-foreground text-primary-foreground hover:bg-primary-foreground hover:text-primary",children:[e.jsx(I,{className:"w-4 h-4 mr-2"}),"Falar com Especialista"]})]}),e.jsxs("div",{className:"mt-8 flex items-center justify-center space-x-8 text-sm opacity-75",children:[e.jsxs("div",{className:"flex items-center",children:[e.jsx(c,{className:"w-4 h-4 mr-1"}),"14 dias grátis"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(c,{className:"w-4 h-4 mr-1"}),"Sem cartão de crédito"]}),e.jsxs("div",{className:"flex items-center",children:[e.jsx(c,{className:"w-4 h-4 mr-1"}),"Cancelamento gratuito"]})]})]})})]}),e.jsx("footer",{id:"contact",className:"border-t bg-muted/30",children:e.jsxs("div",{className:"container mx-auto px-4 py-12",children:[e.jsxs("div",{className:"grid md:grid-cols-4 gap-8 mb-8",children:[e.jsxs("div",{children:[e.jsxs("div",{className:"flex items-center space-x-3 mb-4",children:[e.jsx("div",{className:"w-8 h-8 bg-gradient-primary rounded-lg flex items-center justify-center",children:e.jsx(y,{className:"w-4 h-4 text-primary-foreground"})}),e.jsx("span",{className:"text-lg font-bold",children:"FinanceiroLogotiq"})]}),e.jsx("p",{className:"text-muted-foreground mb-4",children:"A plataforma mais completa para gestão financeira empresarial."}),e.jsxs("div",{className:"flex space-x-4",children:[e.jsx(n,{variant:"ghost",size:"sm",children:e.jsx(ne,{className:"w-4 h-4"})}),e.jsx(n,{variant:"ghost",size:"sm",children:e.jsx(I,{className:"w-4 h-4"})})]})]}),e.jsxs("div",{children:[e.jsx("h3",{className:"font-semibold mb-4",children:"Produto"}),e.jsxs("ul",{className:"space-y-2 text-muted-foreground",children:[e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Dashboard"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"CRM"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Relatórios"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Integrações"})})]})]}),e.jsxs("div",{children:[e.jsx("h3",{className:"font-semibold mb-4",children:"Empresa"}),e.jsxs("ul",{className:"space-y-2 text-muted-foreground",children:[e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Sobre nós"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Carreiras"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Blog"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Imprensa"})})]})]}),e.jsxs("div",{children:[e.jsx("h3",{className:"font-semibold mb-4",children:"Suporte"}),e.jsxs("ul",{className:"space-y-2 text-muted-foreground",children:[e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Central de Ajuda"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Contato"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Status"})}),e.jsx("li",{children:e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Documentação"})})]})]})]}),e.jsxs("div",{className:"border-t pt-8 flex flex-col md:flex-row items-center justify-between",children:[e.jsxs("div",{className:"flex items-center space-x-3 mb-4 md:mb-0",children:[e.jsx("div",{className:"w-6 h-6 bg-gradient-primary rounded flex items-center justify-center",children:e.jsx(y,{className:"w-3 h-3 text-primary-foreground"})}),e.jsx("span",{className:"text-sm text-muted-foreground",children:"© 2024 FinanceiroLogotiq. Todos os direitos reservados."})]}),e.jsxs("div",{className:"flex space-x-6 text-sm text-muted-foreground",children:[e.jsx("a",{href:"#",className:"hover:text-foreground transition-colors",children:"Privacidade"}),e.jsx("a",{href:"/terms",className:"hover:text-foreground transition-colors",children:"Termos"}),e.jsx("a",{href:"/cookies",className:"hover:text-foreground transition-colors",children:"Cookies"}),e.jsx("a",{href:"/analytics",className:"hover:text-foreground transition-colors",children:"Analytics"})]})]})]})})]})};export{Me as default};
