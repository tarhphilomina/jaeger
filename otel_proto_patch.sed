# Substitute Go package name.
s|go.opentelemetry.io/proto/otlp|github.com/jaegertracing/jaeger/proto-gen/otel|g

# Substitute Proto package name.
s| opentelemetry.proto| jaeger|g

# Remove opentelemetry/proto prefix from imports.
s|import "opentelemetry/proto/|import "|g

# Below instructions are copied (and modified) from OTel collector
# https://github.com/open-telemetry/opentelemetry-collector/blob/main/proto_patch.sed
s|^package \(.*\)\;|package \1;\
\
import "gogoproto/gogo.proto";\
\
// Enable gogoprotobuf extensions (https://github.com/gogo/protobuf/blob/master/extensions.md).\
// Enable custom Marshal method.\
option (gogoproto.marshaler_all) = true;\
// Enable custom Unmarshal method.\
option (gogoproto.unmarshaler_all) = true;\
// Enable custom Size method (Required by Marshal and Unmarshal).\
option (gogoproto.sizer_all) = true;\
|

s+bytes trace_id = \(.*\);+bytes trace_id = \1\
  [\
  // Use custom TraceId data type for this field.\
  (gogoproto.nullable) = false,\
  (gogoproto.customtype) = "github.com/jaegertracing/jaeger/model/v2.TraceID",\
  (gogoproto.customname) = "TraceID"\
  ];+g

s+bytes span_id = \(.*\);+bytes span_id = \1\
  [\
  // Use custom SpanId data type for this field.\
  (gogoproto.nullable) = false,\
  (gogoproto.customtype) = "github.com/jaegertracing/jaeger/model/v2.SpanID",\
  (gogoproto.customname) = "SpanID"\
  ];+g

s+bytes parent_span_id = \(.*\);+bytes parent_span_id = \1\
  [\
  // Use custom SpanId data type for this field.\
  (gogoproto.nullable) = false,\
  (gogoproto.customtype) = "github.com/jaegertracing/jaeger/model/v2.SpanID",\
  (gogoproto.customname) = "ParentSpanID"\
  ];+g

s+repeated opentelemetry.proto.common.v1.KeyValue \(.*\);+repeated opentelemetry.proto.common.v1.KeyValue \1\
  [ (gogoproto.nullable) = false ];+g

s+repeated KeyValue \(.*\);+repeated KeyValue \1\
  [ (gogoproto.nullable) = false ];+g

s+AnyValue \(.*\);+AnyValue \1\
  [ (gogoproto.nullable) = false ];+g

s+opentelemetry.proto.resource.v1.Resource resource = \(.*\);+opentelemetry.proto.resource.v1.Resource resource = \1\
  [ (gogoproto.nullable) = false ];+g

s+opentelemetry.proto.common.v1.InstrumentationScope scope = \(.*\);+opentelemetry.proto.common.v1.InstrumentationScope scope = \1\
  [ (gogoproto.nullable) = false ];+g

s+Status \(.*\);+Status \1\
  [ (gogoproto.nullable) = false ];+g

s+repeated Exemplar exemplars = \(.*\);+repeated Exemplar exemplars = \1\
  [ (gogoproto.nullable) = false ];+g

s+Buckets \(.*\)tive = \(.*\);+Buckets \1tive = \2\
  [ (gogoproto.nullable) = false ];+g

# optional fixed64 foo = 1 -> oneof foo_ { fixed64 foo = 1;}
s+optional \(.*\) \(.*\) = \(.*\);+ oneof \2_ { \1 \2 = \3;}+g

s+\(.*\)PartialSuccess partial_success = \(.*\);+\1PartialSuccess partial_success = \2\
  [ (gogoproto.nullable) = false ];+g
