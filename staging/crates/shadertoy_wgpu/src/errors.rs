pub type Result<T> = anyhow::Result<T, Error>;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error(transparent)]
    DeserializationError(#[from] serde_json::Error),
    #[error(transparent)]
    UnexpectedError(#[from] anyhow::Error),
}
