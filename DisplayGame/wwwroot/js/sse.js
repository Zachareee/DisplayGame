//@ts-check
//
/**
 * @type {EventSource?}
 */
let eventFeedSource = null;

/**
 * @param {*} dotNetRef 
 */
export function start(dotNetRef) {
  console.log("Started")
  if (eventFeedSource) eventFeedSource.close();

  const src = new EventSource("/sse");

  src.addEventListener('program', function (e) {
    dotNetRef.invokeMethodAsync('OnEventReceived', JSON.parse(e.data));
  });

  eventFeedSource = src;
}

export function stop() {
  if (eventFeedSource) {
    eventFeedSource.close();
    eventFeedSource = null;
  }
}
