import { getData, getLogger, getParameters } from "./parameters.js";

const toolName = process.env.TOOL_RUN || "foobar";

const params = getParameters();
const data = getData();
const logger = getLogger();

logger.info("start", "Starting tool run", { tool: toolName });
logger.info("input-loaded", "Loaded validated parameters and data paths", {
  tool: toolName,
  parameter_count: Object.keys(params).length,
  data_keys: Object.keys(data).sort(),
});

if (toolName === "foobar") {
  console.log("You are running the template directly. Please change the foobar function.");
  console.log(params);
  console.log(data);
  logger.info("finished", "Template run finished successfully", { tool: toolName });
} else {
  logger.error("error", "Requested tool is not implemented in the template", { tool: toolName });
  console.error(`The toolname ${toolName} is not recognized. Did you forget to implement it?`);
  process.exit(1);
}
