// Utilitário para gerenciar cookies no FinanceiroLogotiq

interface CookieOptions {
  expires?: number; // dias
  path?: string;
  domain?: string;
  secure?: boolean;
  sameSite?: 'Strict' | 'Lax' | 'None';
}

interface UserPreferences {
  theme: 'light' | 'dark' | 'system';
  language: 'pt-BR' | 'en' | 'es';
  notifications: boolean;
  analytics: boolean;
  marketing: boolean;
  sidebarCollapsed: boolean;
  dashboardLayout: 'grid' | 'list';
  currency: 'BRL' | 'USD' | 'EUR';
}

interface AnalyticsData {
  firstVisit: string;
  lastVisit: string;
  visitCount: number;
  pagesVisited: string[];
  sessionDuration: number;
  referrer?: string;
  userAgent: string;
}

class CookieManager {
  private static instance: CookieManager;
  
  private constructor() {}
  
  public static getInstance(): CookieManager {
    if (!CookieManager.instance) {
      CookieManager.instance = new CookieManager();
    }
    return CookieManager.instance;
  }

  // Função básica para definir cookie
  set(name: string, value: string, options: CookieOptions = {}): void {
    const {
      expires = 30,
      path = '/',
      domain,
      secure = true,
      sameSite = 'Lax'
    } = options;

    let cookieString = `${name}=${encodeURIComponent(value)}`;
    
    if (expires) {
      const date = new Date();
      date.setTime(date.getTime() + (expires * 24 * 60 * 60 * 1000));
      cookieString += `; expires=${date.toUTCString()}`;
    }
    
    if (path) cookieString += `; path=${path}`;
    if (domain) cookieString += `; domain=${domain}`;
    if (secure) cookieString += '; secure';
    if (sameSite) cookieString += `; samesite=${sameSite}`;
    
    document.cookie = cookieString;
  }

  // Função para obter cookie
  get(name: string): string | null {
    const nameEQ = name + "=";
    const ca = document.cookie.split(';');
    
    for (let i = 0; i < ca.length; i++) {
      let c = ca[i];
      while (c.charAt(0) === ' ') c = c.substring(1, c.length);
      if (c.indexOf(nameEQ) === 0) {
        return decodeURIComponent(c.substring(nameEQ.length, c.length));
      }
    }
    return null;
  }

  // Função para deletar cookie
  delete(name: string, path: string = '/'): void {
    this.set(name, '', { expires: -1, path });
  }

  // Função para verificar se cookies são suportados
  isSupported(): boolean {
    try {
      this.set('test', 'test');
      const result = this.get('test') === 'test';
      this.delete('test');
      return result;
    } catch {
      return false;
    }
  }

  // Gerenciar preferências do usuário
  setUserPreferences(preferences: Partial<UserPreferences>): void {
    const current = this.getUserPreferences();
    const updated = { ...current, ...preferences };
    
    this.set('user_preferences', JSON.stringify(updated), { expires: 365 });
    
    // Aplicar mudanças imediatamente
    this.applyUserPreferences(updated);
  }

  getUserPreferences(): UserPreferences {
    const defaultPreferences: UserPreferences = {
      theme: 'system',
      language: 'pt-BR',
      notifications: true,
      analytics: true,
      marketing: false,
      sidebarCollapsed: false,
      dashboardLayout: 'grid',
      currency: 'BRL'
    };

    try {
      const stored = this.get('user_preferences');
      if (stored) {
        return { ...defaultPreferences, ...JSON.parse(stored) };
      }
    } catch (error) {
      console.warn('Erro ao carregar preferências do usuário:', error);
    }

    return defaultPreferences;
  }

  // Aplicar preferências ao DOM
  private applyUserPreferences(preferences: UserPreferences): void {
    // Aplicar tema
    if (preferences.theme === 'dark' || 
        (preferences.theme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }

    // Aplicar idioma
    document.documentElement.lang = preferences.language;

    // Disparar evento para outros componentes
    window.dispatchEvent(new CustomEvent('preferencesChanged', { detail: preferences }));
  }

  // Analytics e rastreamento
  trackPageView(page: string): void {
    const analytics = this.getAnalyticsData();
    
    analytics.lastVisit = new Date().toISOString();
    analytics.visitCount += 1;
    
    if (!analytics.pagesVisited.includes(page)) {
      analytics.pagesVisited.push(page);
    }

    this.set('analytics_data', JSON.stringify(analytics), { expires: 730 }); // 2 anos
  }

  getAnalyticsData(): AnalyticsData {
    const defaultAnalytics: AnalyticsData = {
      firstVisit: new Date().toISOString(),
      lastVisit: new Date().toISOString(),
      visitCount: 1,
      pagesVisited: [],
      sessionDuration: 0,
      userAgent: navigator.userAgent
    };

    try {
      const stored = this.get('analytics_data');
      if (stored) {
        return { ...defaultAnalytics, ...JSON.parse(stored) };
      }
    } catch (error) {
      console.warn('Erro ao carregar dados de analytics:', error);
    }

    return defaultAnalytics;
  }

  // Rastrear tempo de sessão
  startSessionTimer(): void {
    const startTime = Date.now();
    
    // Salvar tempo de início
    this.set('session_start', startTime.toString(), { expires: 1 });
    
    // Configurar listener para quando a página for fechada
    window.addEventListener('beforeunload', () => {
      const sessionStart = parseInt(this.get('session_start') || '0');
      if (sessionStart > 0) {
        const duration = Date.now() - sessionStart;
        const analytics = this.getAnalyticsData();
        analytics.sessionDuration += duration;
        this.set('analytics_data', JSON.stringify(analytics), { expires: 730 });
      }
    });
  }

  // Banner de consentimento de cookies
  showCookieConsent(): boolean {
    return !this.get('cookie_consent');
  }

  setCookieConsent(consent: {
    essential: boolean;
    analytics: boolean;
    marketing: boolean;
  }): void {
    this.set('cookie_consent', JSON.stringify({
      ...consent,
      timestamp: new Date().toISOString()
    }), { expires: 365 });

    // Aplicar consentimento
    this.setUserPreferences({
      analytics: consent.analytics,
      marketing: consent.marketing
    });
  }

  // Limpar todos os cookies (exceto essenciais)
  clearNonEssentialCookies(): void {
    const cookies = document.cookie.split(';');
    
    cookies.forEach(cookie => {
      const name = cookie.split('=')[0].trim();
      
      // Manter cookies essenciais
      if (!['auth_token', 'cookie_consent'].includes(name)) {
        this.delete(name);
      }
    });
  }

  // Exportar dados do usuário (para LGPD)
  exportUserData(): Record<string, any> {
    return {
      preferences: this.getUserPreferences(),
      analytics: this.getAnalyticsData(),
      consent: this.get('cookie_consent') ? JSON.parse(this.get('cookie_consent')!) : null,
      timestamp: new Date().toISOString()
    };
  }

  // Verificar se o usuário é novo
  isNewUser(): boolean {
    const analytics = this.getAnalyticsData();
    return analytics.visitCount <= 1;
  }

  // Obter estatísticas de uso
  getUsageStats(): {
    totalVisits: number;
    uniquePages: number;
    totalSessionTime: number;
    averageSessionTime: number;
  } {
    const analytics = this.getAnalyticsData();
    
    return {
      totalVisits: analytics.visitCount,
      uniquePages: analytics.pagesVisited.length,
      totalSessionTime: analytics.sessionDuration,
      averageSessionTime: analytics.visitCount > 0 ? analytics.sessionDuration / analytics.visitCount : 0
    };
  }
}

// Instância singleton
export const cookieManager = CookieManager.getInstance();

// Hooks e utilitários para React
export const useCookies = () => {
  return {
    set: cookieManager.set.bind(cookieManager),
    get: cookieManager.get.bind(cookieManager),
    delete: cookieManager.delete.bind(cookieManager),
    setUserPreferences: cookieManager.setUserPreferences.bind(cookieManager),
    getUserPreferences: cookieManager.getUserPreferences.bind(cookieManager),
    trackPageView: cookieManager.trackPageView.bind(cookieManager),
    getAnalyticsData: cookieManager.getAnalyticsData.bind(cookieManager),
    showCookieConsent: cookieManager.showCookieConsent.bind(cookieManager),
    setCookieConsent: cookieManager.setCookieConsent.bind(cookieManager),
    isNewUser: cookieManager.isNewUser.bind(cookieManager),
    getUsageStats: cookieManager.getUsageStats.bind(cookieManager)
  };
};

// Tipos para exportação
export type { UserPreferences, AnalyticsData, CookieOptions };
