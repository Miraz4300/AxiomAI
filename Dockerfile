# Frontend | AxiomAI
FROM node:lts-alpine AS frontend
RUN npm install pnpm -g
WORKDIR /app
COPY ./package.json /app
COPY ./pnpm-lock.yaml /app
RUN pnpm install
COPY . /app
RUN pnpm run build

# Backend | AXIOM NODE
FROM node:lts-alpine as backend
RUN npm install pnpm -g
WORKDIR /app
COPY /infrastructure/package.json /app
COPY /infrastructure/pnpm-lock.yaml /app
RUN pnpm install
COPY /infrastructure /app
RUN pnpm build

# Infrastructure | AXIOM NODE
FROM node:lts-alpine
RUN npm install pnpm -g
WORKDIR /app
COPY /infrastructure/package.json /app
COPY /infrastructure/pnpm-lock.yaml /app
RUN pnpm install --production && rm -rf /root/.npm /root/.pnpm-store /usr/local/share/.cache /tmp/*
COPY /infrastructure /app
COPY --from=frontend /app/dist /app/public
COPY --from=backend /app/build /app/build
EXPOSE 10829

CMD ["pnpm", "run", "prod"]