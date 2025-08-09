-- Gerar notificações para convites pendentes existentes

-- Inserir notificações para todos os convites pendentes que não têm notificação ainda
INSERT INTO notifications (
    user_id,
    type,
    title,
    message,
    data,
    created_at
)
SELECT 
    om.member_id,
    'organization_invite',
    'Convite para Organização',
    'Você foi convidado por ' || COALESCE(p.email, 'um usuário') || ' para participar de sua organização financeira.',
    jsonb_build_object(
        'organization_member_id', om.id,
        'owner_id', om.owner_id,
        'owner_email', p.email
    ),
    om.created_at
FROM organization_members om
JOIN profiles p ON p.id = om.owner_id
WHERE om.status = 'pending'
  AND NOT EXISTS (
      SELECT 1 FROM notifications n 
      WHERE n.user_id = om.member_id 
        AND n.type = 'organization_invite'
        AND n.data->>'organization_member_id' = om.id::text
  );

-- Verificar resultado
SELECT 'Notificações criadas:' as info;
SELECT 
    n.title,
    p.email as usuario_notificado,
    n.data->>'owner_email' as convidado_por,
    n.created_at
FROM notifications n
JOIN profiles p ON p.id = n.user_id
WHERE n.type = 'organization_invite'
ORDER BY n.created_at DESC;
