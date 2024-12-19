use serde::{Deserialize, Serialize};
use std::{
    collections::HashMap,
    fs::File,
    io::{BufWriter, Read, Write},
    println,
};

#[derive(Debug, Deserialize)]
struct TimeJSON {
    nanos_since_epoch: u64,
}

#[derive(Deserialize, Debug)]
struct TimeIntervalJSON {
    nanos: u64,
}

#[derive(Debug, Deserialize)]
struct SpanJSON {
    begin: TimeJSON,
    span_type: String,
    duration: Option<TimeIntervalJSON>, //why is this null
    children: Vec<SpanJSON>,
}
#[derive(Debug, Deserialize)]
struct InputJSON {
    spans: SpanJSON,
}

#[derive(Debug, Deserialize, Serialize)]
struct SpeedshotFile {
    version: String,
    #[serde(rename = "$schema")]
    schema: String,
    shared: SharedData,
    profiles: Vec<Profile>,
}

#[derive(Debug, Deserialize, Serialize)]
enum ProfileType {
    evented,
    sampled,
}

#[derive(Debug, Deserialize, Serialize)]
enum EventType {
    #[serde(rename = "O")]
    OpenFrame,
    #[serde(rename = "C")]
    CloseFrame,
}

#[derive(Debug, Deserialize, Serialize)]
enum ValueUnit {
    none,
    nanoseconds,
    microseconds,
    milliseconds,
    seconds,
    bytes,
}

#[derive(Debug, Deserialize, Serialize)]
struct Profile {
    r#type: ProfileType,
    name: String,
    unit: ValueUnit,
    startValue: u64,
    endValue: u64,
    events: Vec<Event>,
}

#[derive(Debug, Deserialize, Serialize)]
struct Event {
    r#type: EventType,
    frame: u32,
    at: u64,
}

#[derive(Debug, Deserialize, Serialize)]
struct SharedData {
    frames: Vec<Frame>,
}

#[derive(Debug, Deserialize, Serialize)]
struct Frame {
    name: String,
}

fn main() {
    let file = File::open("./input.json")
        .or(Err("failed to open file"))
        .unwrap();

    let mut buf_reader = std::io::BufReader::new(file);

    let mut json_string = String::new();
    buf_reader
        .read_to_string(&mut json_string)
        .or(Err("failed to read file"))
        .unwrap();

    let parsed: InputJSON = serde_json::from_str(&json_string).unwrap();
    let out = format!("{:?}", parsed);
    println!("{}", &out[0..4]);
    let spans = parsed.spans;
    let mut frames: Vec<Frame> = vec![];
    let mut frames_mapper: HashMap<String, u32> = HashMap::<String, u32>::new();
    index_frames(&spans, &mut frames_mapper, 0, &mut frames);
    let mut events: Vec<Event> = vec![];
    build_events(&spans, &mut frames_mapper, &mut events);
    //    events.sort_by(|a, b| a.at.cmp(&b.at));
    let out = SpeedshotFile {
        version: "0.0.1".to_string(),
        shared: SharedData { frames },
        profiles: vec![Profile {
            startValue: 0,
            endValue: 0,
            events,
            name: "temp".to_string(),
            r#type: ProfileType::evented,
            unit: ValueUnit::nanoseconds,
        }],
        schema: "https://www.speedscope.app/file-format-schema.json".to_string(),
    };
    let file = File::create("result.json").expect("failed to create output file");
    let mut writer = BufWriter::new(file);
    serde_json::to_writer(&mut writer, &out).expect("failed to spawn serde writer");
    writer.flush().expect("failed to flush writer");
}

fn index_frames(
    input: &SpanJSON,
    frame_mapper: &mut HashMap<String, u32>,
    start_ct: u32,
    out: &mut Vec<Frame>,
) {
    let mut ct = start_ct;
    let name = &input.span_type;
    if frame_mapper.get(name).is_none() {
        out.push(Frame { name: name.clone() });
        frame_mapper.insert(name.clone(), ct);
        ct += 1;
    }
    for ele in &input.children {
        index_frames(&ele, frame_mapper, ct, out)
    }
}

static mut slop: u64 = 0;

fn build_events(input: &SpanJSON, frame_mapper: &HashMap<String, u32>, out: &mut Vec<Event>) {
    let frame_idx = frame_mapper
        .get(&input.span_type)
        .expect("Failed to find frame type in index")
        .clone();
    if let Some(duration) = &input.duration {
        let begin = input.begin.nanos_since_epoch;
        if let Some(last) = out.last() {
            unsafe {
                if last.at > begin + slop {
                    slop += last.at - slop;
                    println!("warn: adding slop");
                }
            }
        }
        let end = begin + duration.nanos;

        unsafe {
            out.push(Event {
                r#type: EventType::OpenFrame,
                at: begin + slop,
                frame: frame_idx,
            });
        }
    }
    for ele in &input.children {
        build_events(&ele, frame_mapper, out);
    }
    if let Some(duration) = &input.duration {
        let begin = input.begin.nanos_since_epoch;

        let end = begin + duration.nanos;

        if let Some(last) = out.last() {
            unsafe {
                if last.at > end + slop {
                    slop += last.at - slop;
                    println!("warn: adding slop");
                }
            }
        }
        unsafe {
            out.push(Event {
                r#type: EventType::CloseFrame,
                at: end + slop,
                frame: frame_idx,
            });
        }
    }
}

fn smoketest_formats() {
    let file = File::open("./temp.json")
        .or(Err("failed to open file"))
        .unwrap();

    let mut buf_reader = std::io::BufReader::new(file);

    let mut json_string = String::new();
    buf_reader
        .read_to_string(&mut json_string)
        .or(Err("failed to read file"))
        .unwrap();

    let parsed: InputJSON = serde_json::from_str(&json_string).unwrap();
    let out = format!("{:?}", parsed);
    println!("{}", &out[0..4]);

    let file = File::open("./temp2.json")
        .or(Err("failed to open file"))
        .unwrap();

    let mut buf_reader = std::io::BufReader::new(file);

    let mut json_string = String::new();
    buf_reader
        .read_to_string(&mut json_string)
        .or(Err("failed to read file"))
        .unwrap();

    let parsed: SpeedshotFile = serde_json::from_str(&json_string).unwrap();
    println!("{:?}", parsed);
}
