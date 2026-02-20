import { getParameters, getData } from "./parameters.js";

const toolName = process.env.TOOL_RUN || "foobar";

const params = getParameters();
const data = getData();

if (toolName === "foobar") {
  console.log("You are running the template directly. Please change the foobar function.");
  console.log(params);
  console.log(data);
} else {
  console.error(`The toolname ${toolName} is not recognized. Did you forget to implement it?`);
}
