import React, { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Bell, Check, X, Users } from 'lucide-react';
import { toast } from 'sonner';

interface Notification {
  id: string;
  type: string;
  title: string;
  message: string;
  data: any;
  read: boolean;
  status: 'pending' | 'accepted' | 'rejected';
  created_at: string;
}

export default function NotificationCenter() {
  const { user } = useAuth();
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      loadNotifications();
    }
  }, [user]);

  const loadNotifications = async () => {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .from('notifications')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false });

      if (error) {
        console.error('Erro ao carregar notificações:', error);
        return;
      }

      setNotifications(data || []);
    } catch (error) {
      console.error('Erro ao carregar notificações:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleInviteResponse = async (notificationId: string, organizationMemberId: string, response: 'accepted' | 'rejected') => {
    try {
      // Atualizar status na organization_members
      const { error: orgError } = await supabase
        .from('organization_members')
        .update({ 
          status: response === 'accepted' ? 'active' : 'rejected',
          updated_at: new Date().toISOString()
        })
        .eq('id', organizationMemberId);

      if (orgError) {
        console.error('Erro ao atualizar organization_members:', orgError);
        toast.error('Erro ao processar resposta');
        return;
      }

      // Atualizar notificação
      const { error: notifError } = await supabase
        .from('notifications')
        .update({ 
          status: response,
          read: true,
          updated_at: new Date().toISOString()
        })
        .eq('id', notificationId);

      if (notifError) {
        console.error('Erro ao atualizar notificação:', notifError);
      }

      // Atualizar estado local
      setNotifications(prev => 
        prev.map(notif => 
          notif.id === notificationId 
            ? { ...notif, status: response, read: true }
            : notif
        )
      );

      toast.success(
        response === 'accepted' 
          ? 'Convite aceito! Agora você pode acessar os dados da organização.' 
          : 'Convite rejeitado.'
      );

      // Recarregar página para atualizar seletor de dados
      if (response === 'accepted') {
        setTimeout(() => window.location.reload(), 1500);
      }

    } catch (error) {
      console.error('Erro ao processar resposta:', error);
      toast.error('Erro ao processar resposta');
    }
  };

  const markAsRead = async (notificationId: string) => {
    try {
      const { error } = await supabase
        .from('notifications')
        .update({ read: true })
        .eq('id', notificationId);

      if (!error) {
        setNotifications(prev => 
          prev.map(notif => 
            notif.id === notificationId 
              ? { ...notif, read: true }
              : notif
          )
        );
      }
    } catch (error) {
      console.error('Erro ao marcar como lida:', error);
    }
  };

  const pendingNotifications = notifications.filter(n => n.status === 'pending');
  const unreadCount = notifications.filter(n => !n.read).length;

  if (loading) {
    return <div className="animate-pulse">Carregando notificações...</div>;
  }

  if (notifications.length === 0) {
    return null;
  }

  return (
    <div className="space-y-4">
      {/* Badge de notificações pendentes */}
      {pendingNotifications.length > 0 && (
        <div className="flex items-center space-x-2">
          <Bell className="h-5 w-5 text-orange-500" />
          <Badge variant="destructive">
            {pendingNotifications.length} convite{pendingNotifications.length > 1 ? 's' : ''} pendente{pendingNotifications.length > 1 ? 's' : ''}
          </Badge>
        </div>
      )}

      {/* Lista de notificações */}
      <div className="space-y-3">
        {notifications.map((notification) => (
          <Card 
            key={notification.id} 
            className={`${!notification.read ? 'border-blue-200 bg-blue-50' : ''} ${
              notification.status === 'pending' ? 'border-orange-200 bg-orange-50' : ''
            }`}
          >
            <CardHeader className="pb-2">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <Users className="h-4 w-4 text-blue-600" />
                  <CardTitle className="text-sm">{notification.title}</CardTitle>
                  {!notification.read && (
                    <Badge variant="secondary" className="text-xs">Nova</Badge>
                  )}
                </div>
                <div className="flex items-center space-x-1">
                  {notification.status === 'accepted' && (
                    <Badge variant="default" className="text-xs">Aceito</Badge>
                  )}
                  {notification.status === 'rejected' && (
                    <Badge variant="destructive" className="text-xs">Rejeitado</Badge>
                  )}
                  <span className="text-xs text-gray-500">
                    {new Date(notification.created_at).toLocaleDateString()}
                  </span>
                </div>
              </div>
            </CardHeader>
            
            <CardContent className="pt-0">
              <CardDescription className="mb-3">
                {notification.message}
              </CardDescription>

              {notification.type === 'organization_invite' && notification.status === 'pending' && (
                <div className="flex items-center space-x-2">
                  <Button
                    size="sm"
                    onClick={() => handleInviteResponse(
                      notification.id, 
                      notification.data.organization_member_id, 
                      'accepted'
                    )}
                    className="bg-green-600 hover:bg-green-700"
                  >
                    <Check className="h-4 w-4 mr-1" />
                    Aceitar
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => handleInviteResponse(
                      notification.id, 
                      notification.data.organization_member_id, 
                      'rejected'
                    )}
                  >
                    <X className="h-4 w-4 mr-1" />
                    Rejeitar
                  </Button>
                </div>
              )}

              {notification.status === 'pending' && notification.type !== 'organization_invite' && (
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => markAsRead(notification.id)}
                >
                  Marcar como lida
                </Button>
              )}
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
