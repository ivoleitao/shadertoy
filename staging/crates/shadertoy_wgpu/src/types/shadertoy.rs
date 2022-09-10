use serde::de;
use serde::{Deserialize, Deserializer};

fn bool_from_string<'de, D>(deserializer: D) -> Result<bool, D::Error>
where
    D: Deserializer<'de>,
{
    match String::deserialize(deserializer)?.as_ref() {
        "true" => Ok(true),
        "false" => Ok(false),
        other => Err(de::Error::invalid_value(
            de::Unexpected::Str(other),
            &"true or false",
        )),
    }
}

#[derive(Debug, Deserialize)]
pub struct Info {
    pub id: String,
    pub name: String,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum FilterType {
    None,
    Nearest,
    Linear,
    Mipmap,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum WrapType {
    None,
    Clamp,
    Repeat,
    Mirror,
}

#[derive(Debug, Deserialize)]
pub struct Sampler {
    pub filter: FilterType,
    pub wrap: WrapType,
    #[serde(deserialize_with = "bool_from_string")]
    pub vflip: bool,
    #[serde(deserialize_with = "bool_from_string")]
    pub srgb: bool,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum InputType {
    Texture,
    Volume,
    Cubemap,
    Music,
    Musicstream,
    Mic,
    Buffer,
    Keyboard,
    Video,
    Webcam,
}

#[derive(Deserialize)]
struct ChannelType {
    #[serde(rename = "type")]
    type1: Option<InputType>,
    #[serde(rename = "ctype")]
    type2: Option<InputType>,
}

fn channel_type_from_string<'d, D: Deserializer<'d>>(d: D) -> Result<Option<InputType>, D::Error> {
    let ChannelType { type1, type2 } = ChannelType::deserialize(d)?;
    Ok(type1.or(type2).map(Into::into))
}

#[derive(Debug, Deserialize)]
pub struct Input {
    pub id: String,
    #[serde(rename(deserialize = "filepath"))]
    pub file_path: Option<String>,
    #[serde(deserialize_with = "channel_type_from_string", flatten)]
    pub channel_type: Option<InputType>,
    pub channel: i32,
    pub sampler: Sampler,
}

#[derive(Debug, Deserialize)]
pub struct Output {
    pub id: String,
    pub channel: i32,
}

#[derive(Debug, Deserialize)]
pub struct Renderpass {
    pub name: String,
    #[serde(rename = "type")]
    pub render_pass_type: String,
    pub description: Option<String>,
    pub code: String,
    pub inputs: Vec<Input>,
    pub outputs: Vec<Output>,
}

#[derive(Debug, Deserialize)]
pub struct Shader {
    pub info: Info,
    pub renderpass: Vec<Renderpass>,
}
