const src = {
  prop11: {
    prop21: 21,
    prop22: {
      prop31: 31,
      prop32: 32,
    },
  },
  prop12: 12,
};

const proto = {
  prop11: {
    prop22: null,
  },
};

function projectObject(src, proto) {
  const projectedObj = {};

  for (const key in proto) {
    if (src.hasOwnProperty(key)) {
      const protoVal = proto[key];
      if (
        typeof protoVal === "object" &&
        !Array.isArray(protoVal) &&
        protoVal !== null
      ) {
        projectedObj[key] = projectObject(src[key], protoVal);
      } else {
        projectedObj[key] = src[key];
      }
    }
  }

  return projectedObj;
}

console.log(projectObject(src, proto));
