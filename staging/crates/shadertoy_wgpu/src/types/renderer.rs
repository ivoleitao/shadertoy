use crate::types::Shader;
use crate::Result;
use std::{
    collections::HashMap,
    future::Future
};
use crevice::std140::{AsStd140};

#[repr(C)]
#[derive(Copy, Clone, Debug, bytemuck::Pod, bytemuck::Zeroable)]
struct Vertex {
    position: [f32; 2],
}

impl Vertex {
    fn desc<'a>() -> wgpu::VertexBufferLayout<'a> {
        wgpu::VertexBufferLayout {
            array_stride: std::mem::size_of::<Vertex>() as wgpu::BufferAddress,
            step_mode: wgpu::VertexStepMode::Vertex,
            attributes: &[wgpu::VertexAttribute {
                offset: 0,
                shader_location: 0,
                format: wgpu::VertexFormat::Float32x2,
            }],
        }
    }
}

const VERTICES: &[Vertex] = &[
    Vertex {
        position: [-1.0, -1.0],
    },
    Vertex {
        position: [1.0, -1.0],
    },
    Vertex {
        position: [-1.0, 1.0],
    },
    Vertex {
        position: [1.0, 1.0],
    },
];

const INDICES: &[u16] = &[0, 1, 2, 1, 3, 2];

#[derive(AsStd140, Clone, Copy)]
struct Uniforms {
    time: f32,
    resolution: mint::Vector2<f32>,
    mouse: mint::Vector2<f32>,
    frame: i32,
}

impl Uniforms {
    fn new(
        time: f32,
        resolution: mint::Vector2<f32>,
        mouse: mint::Vector2<f32>,
        frame: i32,
    ) -> Self {
        Self {
            time,
            resolution,
            mouse,
            frame,
        }
    }
}

pub struct Renderer {
    //device: wgpu::Device,
    //queue: wgpu::Queue
}

impl Renderer {
    /*
    pub async fn new() -> impl Future<Output: Renderer> {
        let instance = wgpu::Instance::new(wgpu::Backends::PRIMARY);
        let adapter = instance
            .request_adapter(&wgpu::RequestAdapterOptions {
                power_preference: wgpu::PowerPreference::default(),
                compatible_surface: None,
            })
            .await
            .unwrap();
        let (device, queue) = adapter
            .request_device(&Default::default(), None)
            .await
            .unwrap();

        Renderer {device, queue}
    }
    */
    pub fn new(json: &str) -> Result<Renderer> {
        let shader: Shader = serde_json::from_str(json)?;
        let assets: HashMap<String, Vec<u8>> = HashMap::new();

        Ok(Renderer {})
    }

    /*
    pub fn add_asset(&mut self, name: String, bytes: Vec<u8>) {
        self.assets.insert(name, bytes);
    }
    */

    pub fn export_image(width: u32, height: u32, format: String) -> Option<Vec<u8>> {
        return None;
    }
}
