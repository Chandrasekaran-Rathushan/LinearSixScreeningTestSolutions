// reference
// https://developers.google.com/calendar/api/v3/reference/freebusy/query

// Note: Authorization optional, so we can retrieve response using API_KEY

async function getFreeBusyIntervals(API_KEY, calendarId, timeMin, timeMax) {
  const url = `https://www.googleapis.com/calendar/v3/freeBusy?key=${API_KEY}`;
  const requestBody = {
    timeMin: timeMin,
    timeMax: timeMax,
    timeZone: "UTC",
    items: [{ id: calendarId }],
  };

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestBody),
    });

    if (!response.ok) {
      console.error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    const busyIntervals = data.calendars[calendarId].busy;
    return busyIntervals;
  } catch (error) {
    console.error("Error fetching busy intervals:", error);
    throw error;
  }
}

const API_KEY = "AIzaSyBfaZz9yzUvsJ0x1Z77BcbTNnSVN-xqCUs";
const calendarId =
  "e00e525ba6916915664be6e951950b7aa09ba533a6182250a13b5655cc607d1a@group.calendar.google.com";
const timeMin = "2024-07-01T00:00:00Z";
const timeMax = "2024-07-31T23:59:59Z";

getFreeBusyIntervals(API_KEY, calendarId, timeMin, timeMax)
  .then((busyIntervals) => {
    console.log("Busy intervals:", { busyIntervals });
  })
  .catch((error) => {
    console.error("Error:", error);
  });
