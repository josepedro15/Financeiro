// Script para debugar o problema do Dashboard
// Execute este script no console do navegador (F12)

console.log('=== DEBUG JAVASCRIPT DASHBOARD ===');

// Simular os dados que o Dashboard recebe
const mockTransactions = [
  { transaction_date: '2025-04-01', amount: 100, transaction_type: 'income' },
  { transaction_date: '2025-04-02', amount: 200, transaction_type: 'income' },
  { transaction_date: '2025-04-03', amount: 300, transaction_type: 'income' },
  // ... mais transações
];

// Simular a lógica do Dashboard
const currentYear = 2025;
const allIncomeTransactions = mockTransactions.filter(t => t.transaction_type === 'income');

console.log('Total income transactions:', allIncomeTransactions.length);

// Filtrar por ano (como o Dashboard faz)
const currentYearIncome = allIncomeTransactions.filter(t => {
  const [year, month, day] = t.transaction_date.split('-').map(Number);
  const transactionDate = new Date(year, month - 1, day);
  const transactionYear = transactionDate.getFullYear();
  
  console.log('Transaction:', {
    originalDate: t.transaction_date,
    parsedDate: transactionDate,
    transactionYear,
    currentYear,
    yearMatch: transactionYear === currentYear
  });
  
  return transactionYear === currentYear;
});

console.log('Current year income transactions:', currentYearIncome.length);

// Agrupar por mês (como o Dashboard faz)
const monthlyRevenueMap = new Map();
currentYearIncome.forEach(t => {
  const [year, month, day] = t.transaction_date.split('-').map(Number);
  const transactionDate = new Date(year, month - 1, day);
  const monthIndex = transactionDate.getMonth();
  const currentAmount = monthlyRevenueMap.get(monthIndex) || 0;
  monthlyRevenueMap.set(monthIndex, currentAmount + Number(t.amount));
  
  console.log('Processing transaction:', {
    originalDate: t.transaction_date,
    parsedDate: transactionDate,
    monthIndex,
    amount: t.amount,
    currentAmount,
    newAmount: currentAmount + Number(t.amount)
  });
});

console.log('Monthly revenue map:', Object.fromEntries(monthlyRevenueMap));

// Verificar especificamente abril (mês 3 em JavaScript)
const aprilRevenue = monthlyRevenueMap.get(3) || 0;
console.log('Abril revenue (mês 3):', aprilRevenue);

// Verificar se há problema com timezone
console.log('=== TIMEZONE DEBUG ===');
const testDate = new Date('2025-04-01');
console.log('Test date:', testDate);
console.log('Test date year:', testDate.getFullYear());
console.log('Test date month:', testDate.getMonth());

console.log('=== DEBUG CONCLUÍDO ==='); 