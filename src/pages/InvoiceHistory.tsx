import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useToast } from '@/hooks/use-toast';
import { 
  ArrowLeft, 
  FileText, 
  Download, 
  Eye, 
  Search, 
  Filter, 
  Calendar,
  DollarSign,
  CreditCard,
  CheckCircle,
  Clock,
  AlertCircle,
  XCircle,
  RefreshCw,
  Plus,
  Trash2,
  Edit,
  Copy,
  ExternalLink,
  Mail,
  Phone,
  MapPin,
  User,
  Building,
  Receipt,
  TrendingUp,
  TrendingDown,
  BarChart3,
  PieChart,
  DownloadCloud,
  Printer
} from 'lucide-react';

interface Invoice {
  id: string;
  invoice_number: string;
  client_name: string;
  client_email?: string;
  amount: number;
  status: 'pending' | 'paid' | 'overdue' | 'cancelled';
  due_date: string;
  issue_date: string;
  payment_date?: string;
  description: string;
  items: InvoiceItem[];
  notes?: string;
  created_at: string;
  updated_at: string;
}

interface InvoiceItem {
  id: string;
  description: string;
  quantity: number;
  unit_price: number;
  total: number;
}

export default function InvoiceHistory() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [invoices, setInvoices] = useState<Invoice[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [dateFilter, setDateFilter] = useState<string>('all');
  const [selectedInvoice, setSelectedInvoice] = useState<Invoice | null>(null);
  const [viewMode, setViewMode] = useState<'list' | 'grid'>('list');

  // Mock data for demonstration
  const mockInvoices: Invoice[] = [
    {
      id: '1',
      invoice_number: 'INV-2025-001',
      client_name: 'JOSE PEDRO DA SILVA FERNANDES',
      client_email: 'jopedromkt@gmail.com',
      amount: 2500.00,
      status: 'paid',
      due_date: '2025-01-15',
      issue_date: '2025-01-01',
      payment_date: '2025-01-10',
      description: 'Desenvolvimento de sistema financeiro',
      items: [
        {
          id: '1',
          description: 'Desenvolvimento frontend',
          quantity: 1,
          unit_price: 1500.00,
          total: 1500.00
        },
        {
          id: '2',
          description: 'Desenvolvimento backend',
          quantity: 1,
          unit_price: 1000.00,
          total: 1000.00
        }
      ],
      notes: 'Pagamento realizado via PIX',
      created_at: '2025-01-01T00:00:00Z',
      updated_at: '2025-01-10T00:00:00Z'
    },
    {
      id: '2',
      invoice_number: 'INV-2025-002',
      client_name: 'Carlos Silva',
      client_email: 'carlos@empresa.com',
      amount: 1800.00,
      status: 'pending',
      due_date: '2025-02-15',
      issue_date: '2025-02-01',
      description: 'Consultoria em marketing digital',
      items: [
        {
          id: '3',
          description: 'Análise de mercado',
          quantity: 1,
          unit_price: 800.00,
          total: 800.00
        },
        {
          id: '4',
          description: 'Estratégia de marketing',
          quantity: 1,
          unit_price: 1000.00,
          total: 1000.00
        }
      ],
      created_at: '2025-02-01T00:00:00Z',
      updated_at: '2025-02-01T00:00:00Z'
    },
    {
      id: '3',
      invoice_number: 'INV-2025-003',
      client_name: 'Maria Santos',
      client_email: 'maria@consultoria.com',
      amount: 3200.00,
      status: 'overdue',
      due_date: '2025-01-20',
      issue_date: '2025-01-05',
      description: 'Sistema de gestão empresarial',
      items: [
        {
          id: '5',
          description: 'Módulo de vendas',
          quantity: 1,
          unit_price: 1200.00,
          total: 1200.00
        },
        {
          id: '6',
          description: 'Módulo de estoque',
          quantity: 1,
          unit_price: 1000.00,
          total: 1000.00
        },
        {
          id: '7',
          description: 'Módulo financeiro',
          quantity: 1,
          unit_price: 1000.00,
          total: 1000.00
        }
      ],
      created_at: '2025-01-05T00:00:00Z',
      updated_at: '2025-01-05T00:00:00Z'
    }
  ];

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadInvoices();
  }, [user, navigate]);

  const loadInvoices = async () => {
    try {
      setLoading(true);
      // Por enquanto, usando dados mock
      // TODO: Implementar carregamento real do banco de dados
      setInvoices(mockInvoices);
    } catch (error) {
      console.error('Erro ao carregar faturas:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar histórico de faturas",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'paid':
        return <Badge className="bg-green-100 text-green-800"><CheckCircle className="w-3 h-3 mr-1" />Pago</Badge>;
      case 'pending':
        return <Badge className="bg-yellow-100 text-yellow-800"><Clock className="w-3 h-3 mr-1" />Pendente</Badge>;
      case 'overdue':
        return <Badge className="bg-red-100 text-red-800"><AlertCircle className="w-3 h-3 mr-1" />Vencido</Badge>;
      case 'cancelled':
        return <Badge className="bg-gray-100 text-gray-800"><XCircle className="w-3 h-3 mr-1" />Cancelado</Badge>;
      default:
        return <Badge variant="secondary">{status}</Badge>;
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(amount);
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('pt-BR');
  };

  const filteredInvoices = invoices.filter(invoice => {
    const matchesSearch = invoice.invoice_number.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         invoice.client_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         invoice.client_email?.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesStatus = statusFilter === 'all' || invoice.status === statusFilter;
    
    return matchesSearch && matchesStatus;
  });

  const getTotalAmount = () => {
    return invoices.reduce((total, invoice) => total + invoice.amount, 0);
  };

  const getPaidAmount = () => {
    return invoices.filter(invoice => invoice.status === 'paid')
                  .reduce((total, invoice) => total + invoice.amount, 0);
  };

  const getPendingAmount = () => {
    return invoices.filter(invoice => invoice.status === 'pending')
                  .reduce((total, invoice) => total + invoice.amount, 0);
  };

  const getOverdueAmount = () => {
    return invoices.filter(invoice => invoice.status === 'overdue')
                  .reduce((total, invoice) => total + invoice.amount, 0);
  };

  const handleViewInvoice = (invoice: Invoice) => {
    setSelectedInvoice(invoice);
  };

  const handleDownloadInvoice = (invoice: Invoice) => {
    // TODO: Implementar download da fatura
    toast({
      title: "Download",
      description: `Fatura ${invoice.invoice_number} será baixada`
    });
  };

  const handleSendInvoice = (invoice: Invoice) => {
    // TODO: Implementar envio da fatura por email
    toast({
      title: "Envio",
      description: `Fatura ${invoice.invoice_number} será enviada por email`
    });
  };

  const handleEditInvoice = (invoice: Invoice) => {
    // TODO: Implementar edição da fatura
    toast({
      title: "Edição",
      description: `Editando fatura ${invoice.invoice_number}`
    });
  };

  const handleDeleteInvoice = (invoice: Invoice) => {
    if (!confirm(`Tem certeza que deseja excluir a fatura ${invoice.invoice_number}?`)) return;
    
    // TODO: Implementar exclusão da fatura
    toast({
      title: "Exclusão",
      description: `Fatura ${invoice.invoice_number} será excluída`
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <Button variant="ghost" onClick={() => navigate('/dashboard')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Dashboard
            </Button>
            <div className="w-8 h-8 bg-gradient-primary rounded-lg flex items-center justify-center">
              <Receipt className="w-4 h-4 text-primary-foreground" />
            </div>
            <div>
              <h1 className="text-xl font-semibold">Histórico de Faturas</h1>
              <p className="text-sm text-muted-foreground">Gerencie todas as suas faturas</p>
            </div>
          </div>
          
          <div className="flex items-center space-x-2">
            <Button variant="outline" onClick={loadInvoices}>
              <RefreshCw className="w-4 h-4 mr-2" />
              Atualizar
            </Button>
            <Button>
              <Plus className="w-4 h-4 mr-2" />
              Nova Fatura
            </Button>
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-6">
        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total de Faturas</CardTitle>
              <Receipt className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{invoices.length}</div>
              <p className="text-xs text-muted-foreground">
                {formatCurrency(getTotalAmount())}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Pagas</CardTitle>
              <CheckCircle className="h-4 w-4 text-green-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-green-600">
                {invoices.filter(i => i.status === 'paid').length}
              </div>
              <p className="text-xs text-muted-foreground">
                {formatCurrency(getPaidAmount())}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Pendentes</CardTitle>
              <Clock className="h-4 w-4 text-yellow-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-yellow-600">
                {invoices.filter(i => i.status === 'pending').length}
              </div>
              <p className="text-xs text-muted-foreground">
                {formatCurrency(getPendingAmount())}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Vencidas</CardTitle>
              <AlertCircle className="h-4 w-4 text-red-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-red-600">
                {invoices.filter(i => i.status === 'overdue').length}
              </div>
              <p className="text-xs text-muted-foreground">
                {formatCurrency(getOverdueAmount())}
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Filters */}
        <Card className="mb-6">
          <CardHeader>
            <CardTitle className="flex items-center">
              <Filter className="w-4 h-4 mr-2" />
              Filtros
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="space-y-2">
                <Label htmlFor="search">Buscar</Label>
                <div className="relative">
                  <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="search"
                    placeholder="Número, cliente ou email..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="pl-10"
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="status">Status</Label>
                <Select value={statusFilter} onValueChange={setStatusFilter}>
                  <SelectTrigger>
                    <SelectValue placeholder="Todos os status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos</SelectItem>
                    <SelectItem value="paid">Pagas</SelectItem>
                    <SelectItem value="pending">Pendentes</SelectItem>
                    <SelectItem value="overdue">Vencidas</SelectItem>
                    <SelectItem value="cancelled">Canceladas</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label htmlFor="date">Período</Label>
                <Select value={dateFilter} onValueChange={setDateFilter}>
                  <SelectTrigger>
                    <SelectValue placeholder="Todos os períodos" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos</SelectItem>
                    <SelectItem value="this_month">Este mês</SelectItem>
                    <SelectItem value="last_month">Mês passado</SelectItem>
                    <SelectItem value="this_year">Este ano</SelectItem>
                    <SelectItem value="last_year">Ano passado</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Invoices List */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>Faturas</CardTitle>
                <CardDescription>
                  {filteredInvoices.length} fatura(s) encontrada(s)
                </CardDescription>
              </div>
              <div className="flex items-center space-x-2">
                <Button
                  variant={viewMode === 'list' ? 'default' : 'outline'}
                  size="sm"
                  onClick={() => setViewMode('list')}
                >
                  Lista
                </Button>
                <Button
                  variant={viewMode === 'grid' ? 'default' : 'outline'}
                  size="sm"
                  onClick={() => setViewMode('grid')}
                >
                  Grid
                </Button>
              </div>
            </div>
          </CardHeader>
          <CardContent>
            {filteredInvoices.length === 0 ? (
              <div className="text-center py-8">
                <FileText className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                <h3 className="text-lg font-medium mb-2">Nenhuma fatura encontrada</h3>
                <p className="text-muted-foreground mb-4">
                  Não há faturas que correspondam aos filtros aplicados.
                </p>
                <Button onClick={() => {
                  setSearchTerm('');
                  setStatusFilter('all');
                  setDateFilter('all');
                }}>
                  Limpar Filtros
                </Button>
              </div>
            ) : (
              <div className="space-y-4">
                {filteredInvoices.map((invoice) => (
                  <Card key={invoice.id} className="hover:shadow-md transition-shadow">
                    <CardContent className="p-4">
                      <div className="flex items-center justify-between">
                        <div className="flex-1">
                          <div className="flex items-center space-x-3 mb-2">
                            <h3 className="font-semibold">{invoice.invoice_number}</h3>
                            {getStatusBadge(invoice.status)}
                          </div>
                          
                          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm text-muted-foreground">
                            <div>
                              <div className="flex items-center space-x-1">
                                <User className="w-3 h-3" />
                                <span>{invoice.client_name}</span>
                              </div>
                              {invoice.client_email && (
                                <div className="flex items-center space-x-1">
                                  <Mail className="w-3 h-3" />
                                  <span>{invoice.client_email}</span>
                                </div>
                              )}
                            </div>
                            
                            <div>
                              <div className="flex items-center space-x-1">
                                <DollarSign className="w-3 h-3" />
                                <span className="font-medium">{formatCurrency(invoice.amount)}</span>
                              </div>
                              <div className="flex items-center space-x-1">
                                <Calendar className="w-3 h-3" />
                                <span>Vencimento: {formatDate(invoice.due_date)}</span>
                              </div>
                            </div>
                            
                            <div>
                              <div className="flex items-center space-x-1">
                                <Calendar className="w-3 h-3" />
                                <span>Emissão: {formatDate(invoice.issue_date)}</span>
                              </div>
                              {invoice.payment_date && (
                                <div className="flex items-center space-x-1">
                                  <CheckCircle className="w-3 h-3" />
                                  <span>Pagamento: {formatDate(invoice.payment_date)}</span>
                                </div>
                              )}
                            </div>
                          </div>
                          
                          <p className="text-sm mt-2">{invoice.description}</p>
                        </div>
                        
                        <div className="flex items-center space-x-2">
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleViewInvoice(invoice)}
                          >
                            <Eye className="w-4 h-4" />
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleDownloadInvoice(invoice)}
                          >
                            <Download className="w-4 h-4" />
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleSendInvoice(invoice)}
                          >
                            <Mail className="w-4 h-4" />
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleEditInvoice(invoice)}
                          >
                            <Edit className="w-4 h-4" />
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleDeleteInvoice(invoice)}
                          >
                            <Trash2 className="w-4 h-4" />
                          </Button>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Invoice Detail Modal */}
      {selectedInvoice && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <Card className="w-full max-w-4xl max-h-[90vh] overflow-y-auto">
            <CardHeader>
              <div className="flex items-center justify-between">
                <div>
                  <CardTitle className="flex items-center space-x-2">
                    <FileText className="w-5 h-5" />
                    <span>Fatura {selectedInvoice.invoice_number}</span>
                    {getStatusBadge(selectedInvoice.status)}
                  </CardTitle>
                  <CardDescription>
                    Detalhes completos da fatura
                  </CardDescription>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setSelectedInvoice(null)}
                >
                  <XCircle className="w-4 h-4" />
                </Button>
              </div>
            </CardHeader>
            <CardContent className="space-y-6">
              {/* Client Information */}
              <div>
                <h3 className="font-semibold mb-3">Informações do Cliente</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <Label>Nome</Label>
                    <p className="text-sm">{selectedInvoice.client_name}</p>
                  </div>
                  {selectedInvoice.client_email && (
                    <div>
                      <Label>Email</Label>
                      <p className="text-sm">{selectedInvoice.client_email}</p>
                    </div>
                  )}
                </div>
              </div>

              {/* Invoice Details */}
              <div>
                <h3 className="font-semibold mb-3">Detalhes da Fatura</h3>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div>
                    <Label>Valor Total</Label>
                    <p className="text-lg font-semibold">{formatCurrency(selectedInvoice.amount)}</p>
                  </div>
                  <div>
                    <Label>Data de Emissão</Label>
                    <p className="text-sm">{formatDate(selectedInvoice.issue_date)}</p>
                  </div>
                  <div>
                    <Label>Data de Vencimento</Label>
                    <p className="text-sm">{formatDate(selectedInvoice.due_date)}</p>
                  </div>
                </div>
              </div>

              {/* Items */}
              <div>
                <h3 className="font-semibold mb-3">Itens da Fatura</h3>
                <div className="space-y-2">
                  {selectedInvoice.items.map((item) => (
                    <div key={item.id} className="flex items-center justify-between p-3 border rounded-lg">
                      <div className="flex-1">
                        <p className="font-medium">{item.description}</p>
                        <p className="text-sm text-muted-foreground">
                          {item.quantity} x {formatCurrency(item.unit_price)}
                        </p>
                      </div>
                      <p className="font-semibold">{formatCurrency(item.total)}</p>
                    </div>
                  ))}
                </div>
              </div>

              {/* Notes */}
              {selectedInvoice.notes && (
                <div>
                  <h3 className="font-semibold mb-3">Observações</h3>
                  <p className="text-sm bg-muted p-3 rounded-lg">{selectedInvoice.notes}</p>
                </div>
              )}

              {/* Actions */}
              <div className="flex items-center justify-end space-x-2 pt-4 border-t">
                <Button variant="outline" onClick={() => handleDownloadInvoice(selectedInvoice)}>
                  <Download className="w-4 h-4 mr-2" />
                  Baixar PDF
                </Button>
                <Button variant="outline" onClick={() => handleSendInvoice(selectedInvoice)}>
                  <Mail className="w-4 h-4 mr-2" />
                  Enviar por Email
                </Button>
                <Button variant="outline" onClick={() => handleEditInvoice(selectedInvoice)}>
                  <Edit className="w-4 h-4 mr-2" />
                  Editar
                </Button>
                <Button onClick={() => setSelectedInvoice(null)}>
                  Fechar
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  );
}
