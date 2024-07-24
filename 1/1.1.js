// Assume that d2 will be greater than d1, so to find the difference d1 must be subtracted from d2

// We can add a new method "daysTo" by adding a new property to Date class as following:

Date.prototype.daysTo = function (d2, includeEndDateWithDifference) {
  // throw error if object is not instance of date object
  if (!(d2 instanceof Date)) {
    throw new Error("Must be an instance of Date.");
  }

  const timeDifferenceInMs = d2.getTime() - this.getTime(); // result will be in millisecond

  // convert from milliseconds to days
  const differenceInDays = timeDifferenceInMs / (1000 * 60 * 60 * 24);

  const response = Math.floor(differenceInDays);

  if (includeEndDateWithDifference) {
    return response + 1;
  }
  return response;
};

const d1 = new Date("2024-07-01");
const d2 = new Date("2024-07-10");

console.log(`Start Date: ${d1.toLocaleDateString()} - End Date:  ${d1.toLocaleDateString()}`);
console.log("Without End Date: ", d1.daysTo(d2));
console.log("Including End Date: ", d1.daysTo(d2, true));
