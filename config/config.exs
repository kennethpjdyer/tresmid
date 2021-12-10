import Config

config :tresmid,
  conf_path: Path.expand("~/.config/tresmid.yml"),
  mongo_user: "tresmid",
  mongo_pwd: "tresmid",
  mongo_db: "tresmid",
  mongo_host: "localhost",
  mongo_port: 27017

config :logger, level: :warn
