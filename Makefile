VOCAB_RB := flashcards/scripts/vocab.rb
NAPKIN_LATENCY_RB := flashcards/scripts/napkin_latency.rb
NAPKIN_COST_RB := flashcards/scripts/napkin_cost.rb
NAPKIN_COMPRESSION_RB := flashcards/scripts/napkin_compression.rb
TOML_TO_YAML_RB := flashcards/scripts/toml_to_yaml.rb

# Sources
AWS_SRC := flashcards/sources/aws.csv
NAPKIN_LATENCY_SRC := flashcards/sources/napkin-math-latency.csv
NAPKIN_COST_SRC := flashcards/sources/napkin-math-cost.csv
NAPKIN_COMPRESSION_SRC := flashcards/sources/napkin-math-compression.csv

# TOML cards (for hashcards drilling)
AWS_CARDS := flashcards/cards/aws-regions.md
NAPKIN_LATENCY_CARDS := flashcards/cards/napkin-math-latency.md
NAPKIN_COST_CARDS := flashcards/cards/napkin-math-cost.md
NAPKIN_COMPRESSION_CARDS := flashcards/cards/napkin-math-compression.md

# Jekyll cards (generated from TOML cards)
AWS_JEKYLL := _flashcards/aws-regions.md
NAPKIN_LATENCY_JEKYLL := _flashcards/napkin-math-latency.md
NAPKIN_COST_JEKYLL := _flashcards/napkin-math-cost.md
NAPKIN_COMPRESSION_JEKYLL := _flashcards/napkin-math-compression.md

CARDS_TARGETS := $(AWS_CARDS) $(NAPKIN_LATENCY_CARDS) $(NAPKIN_COST_CARDS) $(NAPKIN_COMPRESSION_CARDS)
JEKYLL_TARGETS := $(AWS_JEKYLL) $(NAPKIN_LATENCY_JEKYLL) $(NAPKIN_COST_JEKYLL) $(NAPKIN_COMPRESSION_JEKYLL)
FLASHCARDS_JSON := _data/flashcards.json

.PHONY: all clean drill

all: $(CARDS_TARGETS) $(JEKYLL_TARGETS) $(FLASHCARDS_JSON)

drill: $(CARDS_TARGETS)
	hashcards drill flashcards/cards --card-limit=50

# Step 1: Generate TOML cards (for hashcards)
$(AWS_CARDS): $(AWS_SRC) $(VOCAB_RB)
	@mkdir -p flashcards/cards
	@echo '---' > $@
	@echo 'name = "AWS Regions"' >> $@
	@echo '---' >> $@
	@echo '' >> $@
	ruby $(VOCAB_RB) $(AWS_SRC) >> $@

$(NAPKIN_LATENCY_CARDS): $(NAPKIN_LATENCY_SRC) $(NAPKIN_LATENCY_RB)
	@mkdir -p flashcards/cards
	ruby $(NAPKIN_LATENCY_RB) $(NAPKIN_LATENCY_SRC) >> $@

$(NAPKIN_COST_CARDS): $(NAPKIN_COST_SRC) $(NAPKIN_COST_RB)
	@mkdir -p flashcards/cards
	ruby $(NAPKIN_COST_RB) $(NAPKIN_COST_SRC) >> $@

$(NAPKIN_COMPRESSION_CARDS): $(NAPKIN_COMPRESSION_SRC) $(NAPKIN_COMPRESSION_RB)
	@mkdir -p flashcards/cards
	ruby $(NAPKIN_COMPRESSION_RB) $(NAPKIN_COMPRESSION_SRC) >> $@

# Step 2: Convert TOML cards to Jekyll YAML
$(AWS_JEKYLL): $(AWS_CARDS) $(TOML_TO_YAML_RB)
	@mkdir -p _flashcards
	ruby $(TOML_TO_YAML_RB) $< > $@

$(NAPKIN_LATENCY_JEKYLL): $(NAPKIN_LATENCY_CARDS) $(TOML_TO_YAML_RB)
	@mkdir -p _flashcards
	ruby $(TOML_TO_YAML_RB) $< > $@

$(NAPKIN_COST_JEKYLL): $(NAPKIN_COST_CARDS) $(TOML_TO_YAML_RB)
	@mkdir -p _flashcards
	ruby $(TOML_TO_YAML_RB) $< > $@

$(NAPKIN_COMPRESSION_JEKYLL): $(NAPKIN_COMPRESSION_CARDS) $(TOML_TO_YAML_RB)
	@mkdir -p _flashcards
	ruby $(TOML_TO_YAML_RB) $< > $@

# Step 3: Export card data to JSON for Jekyll
# Run drill briefly to seed added_at timestamps, then export
$(FLASHCARDS_JSON): $(CARDS_TARGETS)
	@mkdir -p _data
	timeout 1s hashcards drill --open-browser false flashcards/cards || true
	hashcards export flashcards/cards --output $@

clean:
	rm -f $(CARDS_TARGETS) $(JEKYLL_TARGETS) $(FLASHCARDS_JSON)
