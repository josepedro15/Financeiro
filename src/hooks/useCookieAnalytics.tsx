import { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import { cookieManager, type UserPreferences, type AnalyticsData } from '@/utils/cookies';

export const useCookieAnalytics = () => {
  const location = useLocation();
  const [preferences, setPreferences] = useState<UserPreferences>(cookieManager.getUserPreferences());
  const [analytics, setAnalytics] = useState<AnalyticsData>(cookieManager.getAnalyticsData());
  const [isNewUser, setIsNewUser] = useState(cookieManager.isNewUser());

  // Rastrear mudanças de página
  useEffect(() => {
    if (preferences.analytics) {
      cookieManager.trackPageView(location.pathname);
      setAnalytics(cookieManager.getAnalyticsData());
    }
  }, [location.pathname, preferences.analytics]);

  // Iniciar timer de sessão
  useEffect(() => {
    if (preferences.analytics) {
      cookieManager.startSessionTimer();
    }
  }, [preferences.analytics]);

  // Listener para mudanças de preferências
  useEffect(() => {
    const handlePreferencesChange = (event: CustomEvent) => {
      setPreferences(event.detail);
    };

    window.addEventListener('preferencesChanged', handlePreferencesChange as EventListener);
    
    return () => {
      window.removeEventListener('preferencesChanged', handlePreferencesChange as EventListener);
    };
  }, []);

  const updatePreferences = (newPreferences: Partial<UserPreferences>) => {
    cookieManager.setUserPreferences(newPreferences);
    setPreferences(cookieManager.getUserPreferences());
  };

  const getUsageStats = () => {
    return cookieManager.getUsageStats();
  };

  const exportUserData = () => {
    return cookieManager.exportUserData();
  };

  const clearNonEssentialCookies = () => {
    cookieManager.clearNonEssentialCookies();
    setPreferences(cookieManager.getUserPreferences());
    setAnalytics(cookieManager.getAnalyticsData());
  };

  return {
    preferences,
    analytics,
    isNewUser,
    updatePreferences,
    getUsageStats,
    exportUserData,
    clearNonEssentialCookies,
    // Funções utilitárias
    isAnalyticsEnabled: preferences.analytics,
    isMarketingEnabled: preferences.marketing,
    currentTheme: preferences.theme,
    currentLanguage: preferences.language,
    currentCurrency: preferences.currency,
    dashboardLayout: preferences.dashboardLayout,
    sidebarCollapsed: preferences.sidebarCollapsed
  };
};
