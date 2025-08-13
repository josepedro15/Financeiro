import { Suspense, lazy } from "react";
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "@/hooks/useAuth";
import CookieConsent from "@/components/CookieConsent";

// Lazy load components for better performance
const Index = lazy(() => import("./pages/Index"));
const Auth = lazy(() => import("./pages/Auth"));
const Dashboard = lazy(() => import("./pages/Dashboard"));
const Transactions = lazy(() => import("./pages/Transactions"));
const Clients = lazy(() => import("./pages/Clients"));
const Reports = lazy(() => import("./pages/Reports"));
const Settings = lazy(() => import("./pages/Settings"));
const SubscriptionStatus = lazy(() => import("./pages/SubscriptionStatus"));
const PlanSelection = lazy(() => import("./pages/PlanSelection"));
const Checkout = lazy(() => import("./pages/Checkout"));
const UpgradePlan = lazy(() => import("./pages/UpgradePlan"));
const Terms = lazy(() => import("./pages/Terms"));
const Cookies = lazy(() => import("./pages/Cookies"));
const Analytics = lazy(() => import("./pages/Analytics"));
const Privacy = lazy(() => import("./pages/Privacy"));
const InvoiceHistory = lazy(() => import("./pages/InvoiceHistory"));
const NotFound = lazy(() => import("./pages/NotFound"));
const TestPage = lazy(() => import("./pages/TestPage"));
const TestDndWorking = lazy(() => import("./pages/TestDndWorking"));

// Loading component
const PageLoader = () => (
  <div className="min-h-screen flex items-center justify-center">
    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
  </div>
);

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      gcTime: 10 * 60 * 1000, // 10 minutes
      retry: 1,
      refetchOnWindowFocus: false,
      refetchOnMount: true,
    },
    mutations: {
      retry: 1,
    },
  },
});

const App = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <AuthProvider>
          <Toaster />
          <Sonner />
          <CookieConsent />
          <BrowserRouter>
            <Suspense fallback={<PageLoader />}>
              <Routes>
                <Route path="/" element={<Index />} />
                <Route path="/auth" element={<Auth />} />
                <Route path="/dashboard" element={<Dashboard />} />
                <Route path="/transactions" element={<Transactions />} />
                <Route path="/clients" element={<Clients />} />
                <Route path="/reports" element={<Reports />} />
                <Route path="/settings" element={<Settings />} />
                <Route path="/subscription" element={<SubscriptionStatus />} />
                <Route path="/plans" element={<PlanSelection />} />
                <Route path="/upgrade" element={<UpgradePlan />} />
        <Route path="/terms" element={<Terms />} />
        <Route path="/cookies" element={<Cookies />} />
        <Route path="/analytics" element={<Analytics />} />
                                    <Route path="/privacy" element={<Privacy />} />
                            <Route path="/invoices" element={<InvoiceHistory />} />
                            <Route path="/checkout" element={<Checkout />} />
                <Route path="/test" element={<TestPage />} />
                <Route path="/test-dnd" element={<TestDndWorking />} />
                {/* ADD ALL CUSTOM ROUTES ABOVE THE CATCH-ALL "*" ROUTE */}
                <Route path="*" element={<NotFound />} />
              </Routes>
            </Suspense>
          </BrowserRouter>
        </AuthProvider>
      </TooltipProvider>
    </QueryClientProvider>
  );
};

export default App;
