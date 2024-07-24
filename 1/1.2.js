const sales = [
  { amount: 10000, quantity: 10 },
  { amount: 20000, quantity: 20 },
  { amount: 15000, quantity: 20 },
];
const revenue = sales.map((sale) => ({
  ...sale,
  total: sale.amount * sale.quantity,
}));

function sortByTotal(order) {
  revenue.sort((a, b) =>
    order === "desc" ? b.total - a.total : a.total - b.total
  );
  console.log(revenue);
}

function sortByTotalUsingReduce(order) {
  var orderedSales = revenue.reduce((prev, curr) => {
    var index = prev.findIndex((item) =>
      !order || order === "asc"
        ? item.total > curr.total
        : item.total < curr.total
    );

    // if index is -1 make (current length + 1) as next elements position
    if (index === -1) {
      // hhere no need to add +1 since array index starts from 0
      index = prev.length;
    }
    prev.splice(index, 0, curr);
    return prev;
  }, []);

  return orderedSales;
}

console.log(sortByTotal("asc"));
