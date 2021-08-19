use crate::types::Shader;
use crate::Result;
use std::collections::HashMap;

pub struct Renderer {
    shader: Shader,
    assets: HashMap<String, Vec<u8>>,
}

impl Renderer {
    pub fn new(json: &str) -> Result<Renderer> {
        println!("it's ok1");
        let shader: Shader = serde_json::from_str(json)?;
        let assets: HashMap<String, Vec<u8>> = HashMap::new();

        println!("it's ok2");

        Ok(Renderer { shader, assets })
    }

    pub fn add_asset(&mut self, name: String, bytes: Vec<u8>) {
        self.assets.insert(name, bytes);
    }

    pub fn export_image(width: u32, height: u32, format: String) -> Option<Vec<u8>> {
        return None;
    }
}
