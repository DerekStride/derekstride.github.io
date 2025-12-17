VOCAB_RB := flashcards/scripts/vocab.rb
TOML_TO_YAML_RB := flashcards/scripts/toml_to_yaml.rb

# Sources
AWS_SRC := flashcards/sources/aws.csv

# TOML cards (for hashcards drilling)
AWS_CARDS := flashcards/cards/aws-regions.md

# Jekyll cards (generated from TOML cards)
AWS_JEKYLL := _flashcards/aws-regions.md

CARDS_TARGETS := $(AWS_CARDS)
JEKYLL_TARGETS := $(AWS_JEKYLL)

.PHONY: all clean drill

all: $(CARDS_TARGETS) $(JEKYLL_TARGETS)

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

# Step 2: Convert TOML cards to Jekyll YAML
$(AWS_JEKYLL): $(AWS_CARDS) $(TOML_TO_YAML_RB)
	@mkdir -p _flashcards
	ruby $(TOML_TO_YAML_RB) $< > $@

clean:
	rm -f $(CARDS_TARGETS) $(JEKYLL_TARGETS)
