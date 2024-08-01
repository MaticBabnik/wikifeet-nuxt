ARG NODE_VERSION=22.5.1
ARG PORT=3000

FROM node:${NODE_VERSION}-slim as base
WORKDIR /src

# Build stage
FROM base as build
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY --link package.json pnpm-lock.yaml ./
RUN pnpm install
COPY --link . .
RUN pnpm build
RUN pnpm prune --prod

# Run
FROM base
ENV NODE_ENV=production
ENV PORT=$PORT
COPY --from=build /src/.output /src/.output
CMD [ "node", ".output/server/index.mjs" ]